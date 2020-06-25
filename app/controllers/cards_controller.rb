class CardsController < ApplicationController
   protect_from_forgery :except => [:create]  # APIを使用する際のセキュリティが強化され、エラーがでてしまうので、createだけ外しておく
   
  def index  
  end

  def new
  end

  def create
    Payjp.api_key = ENV["PAYJP_SECRET_KEY"]
    customer = Payjp::Customer.create(
    description: 'test',
    card: params[:card_token]
  )

   card = Card.new(
     card_token: params[:card_token],
     customer_token: customer.id,
     user_id: current_user.id
   )
   
   if card.save
    redirect_to root_path
   else
    redirect_to "new"
   end
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
