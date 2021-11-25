class CreateBalances < ActiveRecord::Migration[6.1]
  def change
    create_table :balances do |t|
      t.string :account_id
      t.bigint :balance

      t.timestamps
    end
  end
end
