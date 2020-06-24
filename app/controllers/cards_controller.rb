class CardsController < ApplicationController
  def new
  end

  def create
    Payjp.api_key = ENV["PAYJP_SECRET_KEY"]

    customer = Payjp::Customer.create(card: params[:payjp_token]) 
    card = current_user.build_card(card_token: params[:card_token], customer_token: customer.id)

    if card.save
      redirect_to root_path
    else
      redirect_to new
    end

  end

  def purchase
    @order = Card.new(price: order_params[:price])
    if @order.valid?
      pay_item
      @order.save
      return redirect_to root_path
    end
    render 'new'
  end

  private

  def order_params
    params.permit(:price, :token)
  end

  def pay_item
    Payjp.api_key = ENV["PAYJP_SECRET_KEY"]
    Payjp::Charge.create(
      amount: order_params[:price],
      card: order_params[:token],
      currency:'jpy'
    )
  end

end
