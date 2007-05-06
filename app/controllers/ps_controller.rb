class PsController < ApplicationController

  layout "puresenses"

  def index
    if @psarticle = Article.find_by_title('puresenses startseite', :include => :fragments)
      @psblocklinks = BlockLink.find_by_fragment_id(@psarticle.fragments.first)
    end
    render :layout => "puresenses"
  end

  def article
    if @psarticle = Article.find_by_topic_id(params[:id], :include => :fragments)
      @psblocklinks = BlockLink.find_by_fragment_id(@psarticle.fragments.first)
    end
    render :layout => "puresenses"
  end

end