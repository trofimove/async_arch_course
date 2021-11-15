module Consumers
  class AccountChanges < ApplicationConsumer
    def consume
      params_batch.each do |message|
        payload = message.payload
        data = payload['data']

        return if data['public_id'].blank?

        case payload['event_name']
        when 'AccountCreated'
          Account.create(email: data['email'], full_name: data['full_name'], role: data['role'],
                         active: data['active'], public_id: data['public_id'])
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