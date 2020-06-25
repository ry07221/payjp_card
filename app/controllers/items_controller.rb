class ItemsController < ApplicationController

  def index
    @items = Item.all
  end

  def order
    @order = Order.new(price: order_params[:price])
    if @order.valid?
      pay_item
      @order.save
      return redirect_to root_path
    end
    render 'new'
  end

  private

  def order_params
    params.permit(:price, :card_token)
  end

  def pay_item
    Payjp.api_key = ENV["PAYJP_SECRET_KEY"]
    Payjp::Charge.create(
      amount: order_params[:price],
      card: order_params[:card_token],
      currency:'jpy'
    )
  end
  
end
