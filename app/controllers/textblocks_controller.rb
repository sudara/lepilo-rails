class TextblocksController < ApplicationController

  before_filter :login_required, :except => [ :show, :short, :frontpage ]

  def index
    list
    render :action => 'list'
  end

  def list
    @textblock_pages, @textblocks = paginate :textblocks, :per_page => 10
    if params[:rendersimple]  
      render :layout => "simple"
    end
  end

  def show
    @textblock = Textblock.find(params[:id])
    if params[:rendersimple]  
      render :layout => "simple"
    else
      render_without_layout
    end
  end

  def flashpreview
    @textblock = Textblock.find(params[:id])
    if params[:rendersimple]  
      render :layout => "simple"
    end
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
    if params[:rendersimple]  
      render :layout => "simple"
    end
  end

  def create
    
    @textblock = Textblock.new(params[:textblock])
    if @textblock.save

      @textblock.update
      
      addLink = BlockLink.new
      addLink.textblock_id = @textblock.id
      addLink.fragment_id = session[:current_fragment]
      addLink.save
      
      flash[:notice] = 'Textblock was successfully created.'
      #redirect_to :action => 'list'
      redirect_to :controller=>"/block_links", :action => "close_reload"
    else
      render :action => 'new'
    end
  end

  def edit
    @textblock = Textblock.find(params[:id])
    if params[:rendersimple]  
      render :layout => "simple"
    end
  end

  def update
    @textblock = Textblock.find(params[:id])
    if @textblock.update_attributes(params[:textblock])
      flash[:notice] = 'Textblock was successfully updated.'
      #redirect_to :action => 'show', :id => @textblock
      redirect_to :controller=>"/block_links", :action => "close_reload"
    else
      render :action => 'edit'
    end
  end

  def destroy
    Textblock.find(params[:id]).destroy
    # redirect_to :action => 'list'
    # redirect_to :controller=>"/block_links", :action => "close_reload"
    redirect_to :controller => '/articles', :action => 'edit', :id => session[:current_article]
  end
end
