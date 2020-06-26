class CardsController < ApplicationController
   protect_from_forgery :except => [:create]  # APIを使用する際のセキュリティが強化され、エラーがでてしまうので、createだけ外しておく

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

end
