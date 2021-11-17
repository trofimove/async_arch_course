json.extract! task, :id, :name, :jira_id, :created_by_id, :assignee_id, :status, :assign_amount, :complete_amount, :created_at, :updated_at
json.url task_url(task, format: :json)
