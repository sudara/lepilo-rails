class PsController < ApplicationController

  layout "puresenses"

  def index
    if @psarticle = Article.find_by_title('puresenses startseite', :include => :fragments)
      @psblocks = BlockLink.find_by_fragment_id(@psarticle.fragments.first)
    end
    render :layout => "puresenses"
  end

  def article
    if @psarticle = Article.find(params[:id], :include => :fragments)
      @psblocks = BlockLink.find_by_fragment_id(@psarticle.fragments.first)
    end
    render :layout => "puresenses"
  end

end
