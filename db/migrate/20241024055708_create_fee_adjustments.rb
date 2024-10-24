class CreateFeeAdjustments < ActiveRecord::Migration[7.2]
  def change
    create_table :fee_adjustments do |t|
      t.references :merchant, null: false, foreign_key: true
      t.timestamp :adjustment_date, null: false
      t.integer :adjustment_amount, null: false

      t.timestamps
    end
  end
end
