class Public::OrdersController < ApplicationController
  before_action :check_cart_items, only: [:new]
  def new
    @order = Order.new
  end

  def confirm
    @order = Order.new(order_params)
    @items = CartItem.all
    #        どこで、何を取ってくるか
    @total_price = 0
    set_address
  end

  def create
    @cart_items = current_customer.cart_items.all
    @order = current_customer.orders.new(order_params)
    @order.shipping_cost = 800
    @order.order_status = 0
    @cart_items.each do |cart_item|
      @order_detail = @order.order_details.new
      @order_detail.item_id = cart_item.item_id
      @order_detail.amount = cart_item.amount
      @order_detail.price = cart_item.item.with_tax_price
      @order_detail.making_status = 0
      @order_detail.save
    end
    @cart_items.destroy_all
    @order.save
    redirect_to thanks_path
  end

  def thanks
  end

  def index
    @order = current_customer.orders.all
  end

  def show
    @order = Order.find(params[:id])
    @order_detail = OrderDetail.find(params[:id])
  end

private

  def set_address
    if params[:order][:address_option] == "0"
      @order.postal_code = current_customer.postal_code
      @order.address = current_customer.address
      @order.name = current_customer.full_name
    elsif params[:order][:address_option] == "1"
      @address = Address.find(params[:order][:address_id])
      @order.postal_code = @address.postal_code
      @order.address = @address.address
      @order.name = @address.name
    elsif params[:order][:address_option] == "2"
      @order.postal_code = params[:order][:postal_code]
      @order.address =  params[:order][:address]
      @order.name =  params[:order][:name]
    end
  end

  def order_params
    params.require(:order).permit(:payment_method, :postal_code, :address, :name, :total_amount)
  end

  def order_detail_params
    params.require(:order_detail).permit(:item_id, :order_id, :price, :amount)
  end

  def check_cart_items
    if current_customer.cart_items.blank?
      redirect_to cart_items_path
    end
  end
end
