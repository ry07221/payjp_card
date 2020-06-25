class UsersController < ApplicationController
  # before_action :set_card, only: :show

  def show
    Payjp.api_key = ENV["PAYJP_SECRET_KEY"]

    card = Card.find_by(user_id: current_user.id)
    redirect_to new_card_path and return unless card.present?
    
    customer = Payjp::Customer.retrieve(card.customer_token)
    @card = customer.cards.first
  end

  def update
    if current_user.update(user_params)
      redirect_to root_path
    else
      render :edit
    end
  end

  private

  # def set_card
  #   card = Card.find_by(user_id: current_user.id)
  #   redirect_to new_card_path and return unless card.present?
  # end
  
  def user_params
    params.require(:user).permit(:name, :email)
  end

end
