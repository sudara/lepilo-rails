class BlockLinksController < ApplicationController

  before_filter :login_required, :except => [ :show, :dhn_article, :show_article ]

  model :mediablock
  model :textblock
  
  def index
    list
    render :action => 'list'
  end

  def list
    @block_link_pages, @block_links = paginate :block_links, :per_page => 10
    if params[:rendersimple] = "true" 
      render :layout => "simple"
    end
  end

  def show
    @block_link = BlockLink.find(params[:id])
    if params[:rendersimple] = "true" 
      render :layout => "simple"
    end
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
    if params[:rendersimple] = "true" 
      render :layout => "simple"
    end
  end

  def create
    @block_link = BlockLink.new(params[:block_link])
    if @block_link.save
      flash[:notice] = 'BlockLink was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @block_link = BlockLink.find(params[:id])
    if params[:rendersimple] = "true" 
      render :layout => "simple"
    end
  end

  def update
    @block_link = BlockLink.find(params[:id])
    if @block_link.update_attributes(params[:block_link])
      flash[:notice] = 'BlockLink was successfully updated.'
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
