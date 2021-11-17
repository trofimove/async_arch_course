class Account < ApplicationRecord
  extend Enumerize

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :access_grants,
           class_name: 'Doorkeeper::AccessGrant',
           foreign_key: :resource_owner_id,
           dependent: :delete_all # or :destroy if you need callbacks

  has_many :access_tokens,
           class_name: 'Doorkeeper::AccessToken',
           foreign_key: :resource_owner_id,
           dependent: :delete_all # or :destroy if you need callbacks

  enumerize :role, in: [:admin, :manager, :employee], predicates: true

  after_create do
    account = self.reload

    # ----------------------------- produce event -----------------------
    event = {
      event_name: 'AccountCreated',
      id: SecureRandom.uuid,
      version: 1,
      created_at: Time.now.to_s,
      producer: 'auth',
      data: {
        public_id: account.public_id,
        email: account.email,
        full_name: account.full_name,
        position: account.position,
        role: account.role
      }
    }

    result = SchemaRegistry.validate_event(event, 'accounts.created', version: 1)

    if result.success?
      WaterDrop::SyncProducer.call(event.to_json, topic: 'accounts-stream')
    else
      raise result.failure
    end

    # --------------------------------------------------------------------
  end
end
