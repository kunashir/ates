class CreateAccounts < ActiveRecord::Migration[7.0]
  def change
    create_table :accounts do |t|
      t.string :public_id
      t.string :name
      t.boolean :active
      t.string :role
      t.integer :balance, null: false, default: 0

      t.timestamps
    end
  end
end
