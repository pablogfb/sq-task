class ChangeMoneyToCents < ActiveRecord::Migration[7.2]
  def change
    change_column :merchants, :minimum_monthly_fee, :integer
    change_column :orders, :amount, :integer
    change_column :orders, :disbursed_fee, :integer
    change_column :disbursements, :disbursed_amount, :integer
    change_column :disbursements, :fee_amount, :integer
  end
end
