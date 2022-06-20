class CreateOrderProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :order_products do |t|
      t.integer :order_id
      t.integer :product_id
      t.integer :price
      t.integer :amount
      t.integer :making_status

      t.timestamps
    end
  end
end
