class PsController < ApplicationController

  layout "puresenses"

  def index
    if @psarticle = Article.find_by_title('puresenses startseite', :include => :fragments)
      @psblocks = BlockLink.find_by_fragment_id(@psarticle.fragments.first)
    end
    render :layout => "puresenses"
  end

  def article
    articletopic = Topic.find(params[:id])
    if @psarticle = Article.find_by_topic_id(articletopic, :include => :fragments)
      @psblocks = BlockLink.find_by_fragment_id(@psarticle.fragments.first)
    end
    render :layout => "puresenses"
  end
  
  def events
    @events = Event.find(:all, :order => 'starts_at ASC')
    render :layout => "puresenses"
  end
  
  def news
    @news = Note.find(:all, :order => 'created_at ASC')
    render :layout => "puresenses"
  end

end
