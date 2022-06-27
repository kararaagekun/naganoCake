class Publics::OrdersController < ApplicationController
  def new
    @order = Order.new
    @shipping_addresses = ShippingAddress.where(customer: current_customer)
  end

  def check

    @order = current_customer.orders.new(order_params)

    @cart_products = current_customer.cart_products
    @total_price = @cart_products.sum{|cart_product|cart_product.product.price * 1.1 * cart_product.amount}
    # 送料を代入
    @order.postage = 800
    # 請求金額を代入
    @order.total_money = @order.postage + @total_price
    # ラジオボタンで選択された支払い方法を渡す
    @order.payment_method = params[:order][:payment_method]

    # newの住所欄を参照

    # 自分の住所が択されたとき
    if params[:order][:addresses] == "residence"
      @order.post_code = current_customer.post_code
      @order.address = current_customer.address
      @order.name = current_customer.last_name + current_customer.first_name
    # 登録済み住所が選択されたとき
    elsif params[:order][:addresses] == "shipping_address"
      ship = ShippingAddress.find(params[:order][:shipping_address_id])
      @order.post_code = ship.post_code
      @order.address = ship.address
      @order.name = ship.name

    # 新しいお届け先が選択されたとき
    elsif params[:order][:addresses] == "new_address"
      @order.post_code = params[:order][:postal_code]
      @order.address = params[:order][:address]
      @order.name = params[:order][:name]
    end

    unless @order.valid? == true
      @shipping_addresses = ShippingAddress.where(customer: current_customer)
      render :new
    end
  end

  def create
    @order = current_customer.orders.new(order_params)
    @order.status = 0
    if @order.save

      redirect_to publics_orders_complete_path
    else
      render :check
    end

    # order_productにカート内情報を渡す
    cart_products = current_customer.cart_products

    cart_products.each do |cart_product|
      order_product = OrderProduct.new
      order_product.order_id = @order.id
      order_product.product_id = cart_product.product.id
      order_product.price = (cart_product.product.price*1.1).floor.to_s(:delimited, delimiter: ',')
      order_product.amount = cart_product.amount
      order_product.making_status = 0
      order_product.save
    end

    cart_products.destroy_all

  end

  def complete
  end


  def index
    @orders = current_customer.orders
    #下でも起動する
    #@orders = Order.all
  end

  def show
    @order = Order.find(params[:id])
    @order_products = @order.order_products
  end

  private


  def order_params
    params.require(:order).permit(:post_code, :address, :name, :payment_method, :total_money, :postage, :status)
  end

  def shipping_address_params
    params.require(:order).permit(:post_code, :address, :name)
  end

end