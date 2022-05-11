class CreateAuthIdenties < ActiveRecord::Migration[7.0]
  def change
    create_table :auth_identies do |t|
      t.belongs_to :account, null: false, foreign_key: true
      t.text :uid
      t.text :login
      t.text :token
      t.text :password_hash

      t.timestamps
    end
  end
end
