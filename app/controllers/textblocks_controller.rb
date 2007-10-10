class TextblocksController < ApplicationController

  before_filter :login_required, :except => [ :show, :short, :frontpage ]

  def index
    list
    render :action => 'list'
  end

  def list
    @textblock_pages, @textblocks = paginate :textblocks, :per_page => 25

  end

  def search
    if !params['criteria'] || 0 == params['criteria'].length
      @items = nil
      render :layout => false
    else
      @items = Textblock.find(:all, :order => 'updated_at DESC',
        :conditions => [ 'LOWER(title) OR LOWER(content) LIKE ?', 
        '%' + params['criteria'].downcase + '%' ])
      @mark_term = params['criteria']
      render :layout => false
    end
  end

  def show
    @textblock = Textblock.find(params[:id])
    if params[:simple_layout]  
      render :layout => 'simple'
    else
      render :layout => false
    end
  end

  def flashpreview
    @textblock = Textblock.find(params[:id])

  end

  def short
    @textblock = Textblock.find_by_id(params[:block_id])
    render :layout => false
  end

  def frontpage
    @blocks = Textblock.find_all_by_title("frontpage")
    render :layout => false
  end

  def new
    @textblock = Textblock.new

  end

  def create
    @textblock = Textblock.new(params[:textblock])
    if @textblock.save      
      @textblock.block_links.create(params[:block_link])      
      flash[:ok] = 'Textblock was successfully created.'
      redirect_to :controller=>"block_links", :action => "close_reload"
    else
      flash[:error] = 'Unable to create Textblock.'
      render :action => 'new'
    end
  end

  def edit
    @textblock = Textblock.find(params[:id])
    render :layout => 'simple'
  end

  def update
    @textblock = Textblock.find(params[:id])
    if @textblock.update_attributes(params[:textblock])
      flash[:ok] = 'Textblock was successfully updated.'
      #redirect_to :action => 'show', :id => @textblock
      redirect_to :controller=>"/block_links", :action => "close_reload"
    else
      render :layout => 'simple'
      render :action => 'edit'
    end
  end

  def destroy
    Textblock.find(params[:id]).destroy
    if session[:current_article]
      redirect_to :controller => '/articles', :action => 'edit', :id => session[:current_article]
    elsif session[:current_collection]
      redirect_to :controller => '/collections', :action => 'edit', :id => session[:current_collection]
    else
      redirect_to :action => 'list'
    end    
  end
  
  def destroylink
    BlockLink.find(params[:id]).destroy
    if session[:current_article]
      redirect_to :controller => '/articles', :action => 'edit', :id => session[:current_article]
    elsif session[:current_collection]
      redirect_to :controller => '/collections', :action => 'edit', :id => session[:current_collection]
    else
      redirect_to :action => 'list'
    end    
  end
  
end
