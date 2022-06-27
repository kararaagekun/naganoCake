class Admins::OrderProductsController < ApplicationController
	before_action :authenticate_a!

    def update
		order_detail = OrderProduct.find(params[:id])
		order_detail.update(order_detail_params)

		case order_detail.making_status
		 when "製作中"
				order_detail.order.update(status: "製作中")
		 when "製作完了"
			if  order_detail.making_status == "製作完了"
				order_detail.order.update(status: "発送準備中")
			end
		end
		redirect_to admins_order_path(order_detail.order.id)
    end

	private
   def order_detail_params
		 params.require(:order_product).permit(:making_status)
   end

end


