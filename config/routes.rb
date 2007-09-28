ActionController::Routing::Routes.draw do |map|
  # The priority is based upon order of creation: first created -> highest priority.
  
  # Sample of regular route:
  # map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  # map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # You can have the root of your site routed by hooking up '' 
  # -- just remember to delete public/index.html.
  
  map.resources :users
  map.resource  :session, :controller => 'sessions'
  map.login  '/login', :controller => 'sessions', :action => 'new'
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  

  # Allow downloading Web Service WSDL as a file with an extension
  # instead of a file named 'wsdl'
  map.connect ':controller/service.wsdl', :action => 'wsdl'


  # TODO: go a step further and push all admin controllers to display under /admin
  # While allowing 

  # allow neat perma urls
  # map.connect 'articles',
  #   :controller => 'articles', :action => 'index'
  # map.connect 'articles/showdina4/:page',
  #   :controller => 'articles', :action => 'showdina4',
  #   :page => /\d+/
  # map.connect ':controller/:action/:id/:fragment' 
  # map.connect 'galleries',
  #   :controller => 'galleries', :action => 'index'
  # map.connect 'galleries/showdina4/:id',
  #   :controller => 'galleries', :action => 'showdina4',
  #   :page => /\d+/


  map.resources :topics
  map.resources :articles
  # Install the default route as the lowest priority.
  map.connect ':controller/:action/:id'
    
  # PUBLIC ROUTES
  map.connect '', :controller => 'frontend', :permalink => 'root'
  
  map.connect ':permalink',     :controller => 'frontend'
  map.connect '*/:permalink',   :controller => 'frontend'
end
