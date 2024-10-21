class CreateDisbursements < ActiveRecord::Migration[7.2]
  def change
    create_table :disbursements do |t|
      t.references :merchant, null: false, foreign_key: true
      t.timestamp :disbursed_at, default: nil

      t.timestamps
    end
  end
end
