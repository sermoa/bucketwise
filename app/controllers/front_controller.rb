class FrontController < ApplicationController
  skip_before_filter :authenticate
  
  def index
    render :financial
  end
  
end
