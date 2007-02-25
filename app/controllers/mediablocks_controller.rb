class MediablocksController < ApplicationController

  before_filter :login_required, :except => [ :show, :show_search ]

  def index
    list
    render :action => 'list'
  end

  def list
    @mediablock_pages, @mediablocks = paginate :mediablocks, :order => 'created_at DESC', :per_page => 32
    if params[:rendersimple]  
      render :layout => "simple"
    end
  end

  def search
    if 0 == @params['criteria'].length
      @mediaitems = nil
      render_without_layout
    else
      @mediaitems = Mediablock.find(:all, :order => 'updated_at DESC',
        :conditions => [ 'LOWER(title) LIKE ?', 
        '%' + @params['criteria'].downcase + '%' ], :limit => 12)
      @mark_term = @params['criteria']
      render_without_layout
    end
  end

  def selectmedia
    @mediablock_pages, @mediablocks = paginate :mediablocks, :per_page => 10
    if params[:rendersimple]  
      render :layout => "simple"
    end
  end

  def show
    @mediablock = Mediablock.find(params[:id])
    if params[:rendersimple]  
      render :layout => "simple"
    end
  end

  def show_search
    @mediablocks = Mediablock.find(:all)
    if params[:rendersimple]  
      render :layout => "simple"
    end
  end

  def new
    @mediablock = Mediablock.new
    if params[:rendersimple]  
      render :layout => "simple"
    end
  end

  def create

    @mediablock = Mediablock.new(params[:mediablock])
    if @mediablock.save

      @mediablock.update
      
      addLink = BlockLink.new
      addLink.mediablock_id = @mediablock.id
      addLink.fragment_id = session[:current_fragment]
      addLink.gallery_id = session[:current_gallery]
      addLink.save

      flash[:notice] = 'Mediablock was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @mediablock = Mediablock.find(params[:id])
    if params[:rendersimple]  
      render :layout => "simple"
    end
  end

  def update
    @mediablock = Mediablock.find(params[:id])
    if @mediablock.update_attributes(params[:mediablock])
      flash[:notice] = 'Mediablock was successfully updated.'
      redirect_to :action => 'show', :id => @mediablock
    else
      render :action => 'edit'
    end
  end

  def destroy
    Mediablock.find(params[:id]).destroy
    redirect_to :action => 'list'
  end

  def destroylink
    BlockLink.find(params[:id]).destroy
    redirect_to :controller => '/articles', :action => 'edit', :id => session[:current_article]
  end
end