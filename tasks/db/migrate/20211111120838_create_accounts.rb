class CreateAccounts < ActiveRecord::Migration[6.1]
  def change
    create_table :accounts do |t|
      t.string :full_name
      t.string :public_id, null: false, unique: true
      t.string :email, null: false, unique: true
      t.string :role, null: false
      t.string :active, default: true
      t.timestamps
    end
  end
end
