class FrontendController < ApplicationController

  layout "frontend"
  before_filter :find_article, :set_fragment

  def index
    if @psarticle = Article.find_by_title('puresenses startseite', :include => :fragments)
      @psblocks = BlockLink.find_by_fragment_id(@psarticle.fragments.first)
    end
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
 
 def set_fragment
   @fragment ||= @topic.article.first.fragment.first
 end
 
 def find_article
   @topic ||= Topic.find_by_permalink params[:permalink], :include => [:article => [:fragments => :block_links]]
 end
end
