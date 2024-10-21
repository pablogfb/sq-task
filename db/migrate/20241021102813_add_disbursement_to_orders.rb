class AddDisbursementToOrders < ActiveRecord::Migration[7.2]
  def change
    add_reference :orders, :disbursement, foreign_key: true, default: nil
  end
end
