class Publics::ProductsController < ApplicationController

  before_action :authenticate_customer!, except: [:index, :show]

  def index
    @products = Product.page(params[:page])
  end

  def show
    @product = Product.find(params[:id])
    @cart_product = CartProduct.new
  end

end
