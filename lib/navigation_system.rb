module NavigationSystem
  
   # Inspired (and some code straight lifted) by mephisto's half-built plugin system
      
   # These variables contain all navigation and route related information for lepilo
   @@custom_routes = []
   @@tabs          = []
   @@admin_tabs    = []

   def lepilo_tabs
     @@tabs
   end
   
   def lepilo_admin_tabs
     @@admin_tabs
   end

   # hook into ActionView to make these tabs avalible in views
   def self.included(base)
     base.send :helper_method, :lepilo_tabs, :lepilo_admin_tabs
   end
   
  
  # This function can be used to add a tab to lepilo's menu
  # Each item has an image as the first argument, and then an array to be passed to link_to
  # add_tab 'path/to/image.png', :controller => 'foo'
  def add_lepilo_tab(*args)
    @@tabs << args
  end
  
  # Keeps track of custom adminstration tabs for ADMIN users only.  
  # Each item is an array of arguments to be passed to tab_for.
  def add_lepilo_admin_tab(*args)
    @@admin_tabs << args
  end
  
 # Adds a custom route to Mephisto from a plugin.  These routes are created in the order they are added.  
  # They will be the last routes before the Mephisto Dispatcher catch-all route.
  def add_route(*args)
    @@custom_routes << args
  end


end
