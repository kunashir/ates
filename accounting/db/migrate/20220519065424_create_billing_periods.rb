class CreateBillingPeriods < ActiveRecord::Migration[7.0]
  def change
    create_table :billing_periods do |t|
      t.datetime :start_date, null: false
      t.datetime :end_date, null: false
      t.integer :status, null: false, default: 0

      t.timestamps
    end
  end
end
