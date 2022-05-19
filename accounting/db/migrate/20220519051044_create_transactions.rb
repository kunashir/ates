class CreateTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :transactions do |t|
      t.belongs_to :account, null: false, foreign_key: true
      t.string :reason, null: false
      t.integer :debit, null: false
      t.integer :credit, null: false

      t.timestamps
    end
  end
end
