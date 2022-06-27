class Publics::CartProductsController < ApplicationController
before_action :authenticate_customer!
  def index
    @cart_products = current_customer.cart_products
    # 単価(税込)と数量を掛けてsumで合計を出す
    @total_price = @cart_products.sum{|cart_product|cart_product.product.price * 1.1 * cart_product.amount}
  end

  def create
    @cart_product = current_customer.cart_products.new(cart_product_params)
    # 商品を追加した場合まずカート内に存在するか確認
    @update_cart_product = CartProduct.find_by(product_id: @cart_product.product_id)
    # 存在した場合、カート内の個数をフォームから送られてきた個数分追加
    if @update_cart_product.present?
      @cart_product.amount += @update_cart_product.amount.to_i
      @update_cart_product.destroy
    end

    @cart_product.save
    redirect_to publics_cart_products_path
  end

  def update
    @cart_product = CartProduct.find(params[:id])
    @cart_product.update(cart_product_params)
    redirect_to publics_cart_products_path
  end

  def destroy
    @cart_product = CartProduct.find(params[:id])
    @cart_product.destroy
    redirect_to publics_cart_products_path
  end

  def destroy_all
    @cart_products = current_customer.cart_products
    @cart_products.destroy_all
    redirect_to publics_cart_products_path
  end



  private

  def cart_product_params
      params.require(:cart_product).permit(:product_id, :amount)
  end
end
