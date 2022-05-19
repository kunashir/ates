class CreateTasks < ActiveRecord::Migration[7.0]
  def change
    create_table :tasks do |t|
      t.string :public_id, null: false
      t.text :description
      t.belongs_to :account, null: false, foreign_key: true
      t.integer :price_assignment, null: false
      t.integer :price_complition, null: false

      t.timestamps
    end
  end
end
