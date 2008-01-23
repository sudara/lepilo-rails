class BlockLinksController < ApplicationController

  before_filter :login_required, :except => [ :show, :dhn_article, :show_article ]

  def index
    list
    render :action => 'list'
  end

  def list
    @block_link_pages, @block_links = paginate :block_links, :per_page => 25

  end

  def show
    @block_link = BlockLink.find(params[:id])

  end
  
  def show_article
    @blocks = BlockLink.find_all_by_fragment_id(params[:fragment_id], :order => "position ASC")
    render :layout => false
  end

  def dhn_article
    @blocks = BlockLink.find_all_by_fragment_id(params[:fragment_id], :order => "position ASC")
    render :layout => false
  end
  
  def close_reload
    # gack
  end

  def new
    @block_link = BlockLink.new

  end

  def create
    @article = Article.find(session[:current_article])
    
    drop_type = params[:id].split('_')[0]  
    drop_id = params[:id].split('_')[1]  
    
    if params[:dropfragment_id]
      drop_into_fragment = params[:dropfragment_id]
    elsif params[:fragment]
      drop_into_fragment = @article.fragments.find_by_content(params[:fragment]).id
    else
      drop_into_fragment = @article.fragments.find_by_content('web').id
    end
    
    @block_link = BlockLink.new 
    # unless @block_link = BlockLink.find_by_fragment_id_and_position(drop_into_fragment, blockdata['position'])
    @block_link.fragment_id = drop_into_fragment

    case drop_type
      when 'dragtextblock'
        @link_to = Textblock.find(drop_id)
      when 'dragmediablock'
        @link_to = Mediablock.find(drop_id)
      when 'dragcollection'
        @link_to = Collection.find(drop_id)
      when 'dragarticle'
        @link_to = Article.find(drop_id)
    end
    
    @block_link.linked = @link_to
    
    if params['position']
      @block_link.update
      @block_link.position = params['position']
    end
    
    if @block_link.save!
      flash[:ok] = 'BlockLink was successfully created.'
      redirect_to :controller => 'articles', :action => 'edit', :id => @article, :params => {:nolayout => true}
      # render :nothing => true
    end
  end

  def edit
    @block_link = BlockLink.find(params[:id])
  end

  def update
    @block_link = BlockLink.find(params[:id])
    if @block_link.update_attributes(params[:block_link])
      flash[:ok] = 'BlockLink was successfully updated.'
      redirect_to :action => 'show', :id => @block_link
    else
      render :action => 'edit'
    end
  end

  def destroy
    BlockLink.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
