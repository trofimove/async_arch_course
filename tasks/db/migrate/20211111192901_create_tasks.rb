class CreateTasks < ActiveRecord::Migration[6.1]
  def change
    create_table :tasks do |t|
      t.string :name
      t.string :created_by_id
      t.string :assignee_id
      t.string :status
      t.string :assign_amount
      t.string :complete_amount

      t.timestamps
    end
  end
end
