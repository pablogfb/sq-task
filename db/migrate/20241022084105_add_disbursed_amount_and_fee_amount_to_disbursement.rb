class AddDisbursedAmountAndFeeAmountToDisbursement < ActiveRecord::Migration[7.2]
  def change
    add_column :disbursements, :disbursed_amount, :float
    add_column :disbursements, :fee_amount, :float
  end
end
