class AddTransaction < ActiveRecord::Migration[6.1]
  def change
    create_table :transactions do |t|
      t.bigint :balance_id
      t.integer :amount
      t.integer :task_id

      t.timestamps
    end
  end
end
