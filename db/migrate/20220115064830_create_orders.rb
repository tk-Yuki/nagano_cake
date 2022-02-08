class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.integer :customer_id
      t.string :postal_code
      t.string :address
      t.string :name
      t.integer :payment_method
      t.integer :total_amount
      t.integer :shipping_cost
      t.integer :order_status

      t.timestamps
    end
  end
end
