module NavigationSystem
   
   # <a href="/settings/" <%= 'class="active"' if params[:controller] == "settings"%>><img src="/images/overview.png" alt="overview" /></a>
   # <a href="/topics/" <%= 'class="active"' if params[:controller] == "topics"%>><img src="/images/navigation.png" alt="navigation"/></a>
   # <a href="/articles/" <%= 'class="active"' if params[:controller] == "articles"%>><img src="/images/articles.png" alt="articles" /></a>
   # <a href="/collections/" <%= 'class="active"' if params[:controller] == "collections"%>><img src="/images/collections.png" alt="collections"/></a>
   # <a href="/mediablocks/" <%= 'class="active"' if params[:controller] == "mediablocks"%>><img src="/images/media.png" alt="media"/></a>
   # <a href="/textblocks/" <%= 'class="active"' if params[:controller] == "textblocks"%>><img src="/images/textblocks.png" alt="textblocks"/></a>
   # <a href="/account/" <%= 'class="active"' if params[:controller] == "account"%>><img src="/images/accounts.png" alt="accounts"/></a>
   # <a href="/account/logout" ><img src="/images/logout.png" alt="log out of lepilo"/></a> 
   
   
  

  def load_navigation
    # cache it, baby
    @@navigation ||= nil 
  end
  
  def update_navigation
    @@navigation = nil
    load_navigation
  end
  
  protected
  
  def add_navigation_item(path = nil)
    
  end
  
end