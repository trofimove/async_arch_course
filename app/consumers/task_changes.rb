module Consumers
  class TaskChanges < ApplicationConsumer
    def consume
      params_batch.each do |message|
        payload = message.payload
        data = payload['data']

        return if data['public_id'].blank?

        case payload['event_name']
        when 'TaskCreated'
          Task.create(name: data['name'], created_by_id: data['created_by_id'], assignee_id: data['assignee_id'],
                      status: data['status'], public_id: data['public_id'], jira_id: data['jira_id'])
        when 'TaskUpdated'
          task = Task.find_by(public_id: data['public_id'])
          return if task.blank?

          task.update(name: data['name'], assignee_id: data['assignee_id'], status: data['status'], jira_id: data['jira_id'])

          if task.previous_changes.has_key?('assignee_id')
            task.assign_amount = rand(10..20)
          end

          if task.previous_changes.has_key?('status') && task.done?
            task.complete_amount = rand(20..40)
          end
        end
      end
    end
  end
end