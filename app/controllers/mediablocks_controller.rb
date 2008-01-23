class MediablocksController < ApplicationController

  before_filter :login_required, :except => [ :show, :show_search ]
  upload_status_for :create

  Mediablock.content_columns.each do |column| 
    in_place_edit_for :mediablock, column.name 
  end 

  def index
    list
    render :action => 'list'
  end

  def list
    session[:current_fragment] = nil
    session[:current_collection] = nil
    
    @mediablocks = Mediablock.find(:all)

  end

  def search
    if !params['criteria'] || 0 == params['criteria'].length
      @mediaitems = nil
      render :layout => false
    else
      @mediaitems = Mediablock.find(:all, :order => 'updated_at DESC',
        :conditions => [ 'LOWER(title) OR LOWER(description) LIKE ?', 
        '%' + params['criteria'].downcase + '%' ], :limit => 18)
      @mark_term = params['criteria']
      render :layout => false
    end
  end

  def selectmedia
    @mediablock_pages, @mediablocks = paginate :mediablocks, :per_page => 25

  end

  def show
    @mediablock = Mediablock.find(params[:id])

  end

  def show_search
    @mediablocks = Mediablock.find(:all)

  end

  def new
    @mediablock = Mediablock.new

  end

  def create
    @mediablock = Mediablock.new(params[:mediablock])
    @mediablock.uploaded_at = DateTime.new(1970, 01, 01, 01, 01).to_s(:db)
    
    #flash[:info] = "Resize set to #{self.resize}"
    
    if @mediablock.save

      # @mediablock.update
      
      addLink = BlockLink.new
      addLink.linked = @mediablock
      addLink.fragment_id = session[:current_fragment]
      addLink.collection_id = session[:current_collection]
      addLink.save

      flash[:ok] = 'Mediablock was successfully created.'
      redirect_to :controller=>"/block_links", :action => "close_reload"
    else
      flash[:error] = 'Unable to create Mediablock.'
      render :action => 'new'
    end    
  end

  def edit
    @mediablock = Mediablock.find(params[:id])

  end

  def update
    @mediablock = Mediablock.find(params[:id])
    if @mediablock.update_attributes(params[:mediablock])
      flash[:ok] = 'Mediablock was successfully updated.'
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
    if session[:current_article]
      redirect_to :controller => '/articles', :action => 'edit', :id => session[:current_article]
    elsif session[:current_collection]
      redirect_to :controller => '/collections', :action => 'edit', :id => session[:current_collection]
    else
      render :nothing => true
    end    
  end
end
