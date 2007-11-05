class FrontendController < ApplicationController

  layout 'frontend'
  skip_before_filter :ensure_default_tabs, :simple_layout
  before_filter :first_timer?, :is_root?, :find_topic, :set_root
  def index
    @content_groups = @topic.article
  end

 # def article
 #   articletopic = Topic.find(params[:id])
 #   if @psarticle = Article.find_by_topic_id(articletopic, :include => :fragments)
 #     @psblocks = BlockLink.find_by_fragment_id(@psarticle.fragments.first)
 #   end
 # end
 # 
 # def events
 #   @events = Event.find(:all, :order => 'starts_at ASC')
 # end
 # 
 # def news
 #   @news = Note.find(:all, :order => 'created_at ASC')
 # end
 
 protected
 
 def find_topic
   @topic ||= Topic.find_by_permalink params[:permalink], :include => [:article => [:fragments => :block_links]]
 end
 
 def is_root?
   @topic ||= Topic.find(:first) unless params[:permalink]
 end
 
 def menu
   @menu ||= Topic.find_by_released(true, :include => :article)
 end
 
 def set_root
   @root_topic  = Topic.root
   @root_topics = @root_topic.children
 end
 
 # Handles user when they try and view the front end without content
 def first_timer?
   if Topic.count < 2 && !logged_in?
     flash[:info] = "Welcome to Lepilo! <br/>Please #{(User.count > 0) ? 'login' : 'create a new account' } to get started."
     redirect_to login_url
   elsif Article.count < 1
     flash[:info] = "Go ahead and create at least one navigation item before checking out the front end"
     redirect_to topics_url
   end
   
 end
  
end
