class FrontController < ApplicationController
  skip_before_filter :authenticate
  
  def index
    render :action => current_site, :layout => current_site
  end
  
  def financial; end

  private
  def current_site
    current_session_site = session[:current_site]
    if current_session_site.nil? or !controller_actions.include?(current_session_site)
      session[:current_site] = random_site
      return session[:current_site]
    end
    
    current_session_site
  end
  
  def random_site
    controller_actions.choice
  end
  
  def controller_actions
    FrontController.public_instance_methods(false).reject { |m| m == 'index' }
  end
end