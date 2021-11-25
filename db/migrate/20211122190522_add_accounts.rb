class AddAccounts < ActiveRecord::Migration[6.1]
  def change
    create_table :accounts do |t|
      t.string :full_name
      t.uuid :public_id, null: false, unique: true
      t.string :email, null: false, unique: true
      t.string :role, null: false
      t.string :active, default: true
      t.timestamps
    end
  end
end
