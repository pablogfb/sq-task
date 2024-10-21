class CreateOrders < ActiveRecord::Migration[7.2]
  def change
    create_table :orders do |t|
      t.references :merchant, null: false, foreign_key: true
      t.float :amount
      t.boolean :disbursed, default: false, null: false
      t.float :disbursed_fee

      t.timestamps
    end
  end
end
