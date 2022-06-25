class Publics::ShippingAddressesController < ApplicationController
  before_action :authenticate_customer!

  def index
    @shipping_address = ShippingAddress.new
    @shipping_addresses = current_customer.shipping_addresses
  end

  def create
    @shipping_address = current_customer.shipping_addresses.new(shipping_address_params)
    if @shipping_address.save
      redirect_to publics_shipping_addresses_path
    else
      @shipping_addresses = ShippingAddress.where(customer_id: current_customer.id)
      render :index
    end
  end

  def edit
    @shipping_address = current_customer.shipping_addresses.find(params[:id])
  end

  def update
    @shipping_address = current_customer.shipping_addresses.find(params[:id])
    if @shipping_address.update(shipping_address_params)
      redirect_to publics_shipping_addresses_path(@shipping_address)
    else
      render :edit
    end
  end

  def destroy
    @shipping_address = current_customer.shipping_addresses.find(params[:id])
    @shipping_address.destroy
    redirect_to publics_shipping_addresses_path
  end

private

  def shipping_address_params
    params.require(:shipping_address).permit(:post_code, :address, :name)
  end

end
