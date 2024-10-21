class CreateMerchants < ActiveRecord::Migration[7.2]
  def change
    create_table :merchants do |t|
      t.string :reference, null: false
      t.string :email, null: false
      t.timestamp :live_on, null: false
      t.integer :disbursement_frequency, null: false, default: 1
      t.float :minimum_monthly_fee, null: false, default: 0

      t.timestamps
    end
  end
end
