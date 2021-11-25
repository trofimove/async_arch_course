class AddTasks < ActiveRecord::Migration[6.1]
  def change
    create_table :taks do |t|
      t.string :name
      t.string :created_by_id
      t.string :assignee_id
      t.string :status
      t.string :jira_id
      t.string :assign_amount
      t.string :complete_amount
      t.uuid :public_id, default: "gen_random_uuid()", null: false

      t.timestamps
    end
  end
end
