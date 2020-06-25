class ItemsController < ApplicationController
  before_action :find_item, only: :order

  def index
    @items = Item.all
  end

  def order
    Payjp.api_key = ENV["PAYJP_SECRET_KEY"]
    customer_token = current_user.card.customer_token
    Payjp::Charge.create(
      amount: @item.price, 
      customer: customer_token, 
      currency: 'jpy'  
    )
    redirect_to items_path(@item)
  end

  private

  def find_item
    @item = Item.find(params[:id])
  end

end
