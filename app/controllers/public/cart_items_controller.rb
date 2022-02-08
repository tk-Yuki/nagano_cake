class Public::CartItemsController < ApplicationController

  def index
    @cart_items = current_customer.cart_items.all
    @total_price = 0
  end

  def update
    @cart_item = current_customer.cart_items
    @cart_item.update(cart_item_params)
    redirect_to cart_items_path
  end

  def create
    @cart_item = current_customer.cart_items.find_by(item_id: params[:cart_item][:item_id])
    if @cart_item
      @cart_item.amount += params[:cart_item][:amount].to_i
    else
      @cart_item = current_customer.cart_items.new(cart_item_params)
    end
    @cart_item.save
    redirect_to cart_items_path

  end

  def destroy
    cart_item = CartItem.find(params[:id])
    if cart_item.customer_id == current_customer.id
       cart_item.destroy
       redirect_to cart_items_path
    else
       redirect_to root_path
    end

  end

  def destroy_all
    CartItem.destroy_all
    redirect_to cart_items_path
  end

  private
  def cart_item_params
    params.require(:cart_item).permit(:amount, :item_id, :customer_id)
  end
end
