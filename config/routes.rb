ActionController::Routing::Routes.draw do |map|
  map.resource :session

  map.resources :subscriptions, :has_many => [:accounts, :events, :tags]
  map.resources :events, :has_many => :tagged_items, :member => { :update => :post }
  map.resources :buckets, :has_many => :events
  map.resources :accounts, :has_many => [:buckets, :events, :statements]
  map.resources :tags, :has_many => :events
  map.resources :tagged_items, :statements

  map.with_options :controller => "front", :action => "index" do |home|
    home.root
    home.connect ""
  end
  
  map.login '/login', :controller => 'sessions', :action => 'new'
end
