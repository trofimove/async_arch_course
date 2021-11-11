module Consumers
  class AccountChanges < ApplicationConsumer
    def consume
      params_batch.each do |message|
          payload = message.payload
          data = payload['data']

          case payload['event_name']
          when 'AccountCreated'
            account = Account.where(public_id: data['public_id']).first_or_initialize
            account.email = data['email']
            account.full_name = data['full_name']
            account.role = data['role']
            account.active = data['active']
            account.save

          when 'AccountUpdated'
            Account.find_by(public_id: data['public_id'])&.update(full_name: data['full_name'])
          when 'AccountDeleted'
            Account.find_by(public_id: data['public_id'])&.update(active: false, disabled_at: Time.now)
          when 'AccountRoleChanged'
            Account.find_by(public_id: data['public_id'])&.update(role: data['role'])
          end

      end
    end
  end
end