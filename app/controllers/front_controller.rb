class FrontController < ApplicationController
  skip_before_filter :authenticate
  
  def index
    if logged_in?
      user = User.find(session[:user_id])
      redirect_to(subscription_path(user.subscriptions.first))
    else
      render :financial
    end
  end
  
end
