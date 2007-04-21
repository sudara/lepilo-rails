class MediablocksController < ApplicationController

  before_filter :login_required, :except => [ :show, :show_search ]
  upload_status_for :create

  def index
    list
    render :action => 'list'
  end

  def list
    @mediablock_pages, @mediablocks = paginate :mediablocks, :order => 'created_at DESC', :per_page => 24
    if params[:rendersimple]  
      render :layout => 'simple'
    end
  end

  def search
    if !@params['criteria'] || 0 == @params['criteria'].length
      @mediaitems = nil
      render_without_layout
    else
      @mediaitems = Mediablock.find(:all, :order => 'updated_at DESC',
        :conditions => [ 'LOWER(title) LIKE ?', 
        '%' + @params['criteria'].downcase + '%' ], :limit => 18)
      @mark_term = @params['criteria']
      render_without_layout
    end
  end

  def selectmedia
    @mediablock_pages, @mediablocks = paginate :mediablocks, :per_page => 10
    if params[:rendersimple]  
      render :layout => 'simple'
    end
  end

  def show
    @mediablock = Mediablock.find(params[:id])
    if params[:rendersimple]  
      render :layout => 'simple'
    end
  end

  def show_search
    @mediablocks = Mediablock.find(:all)
    if params[:rendersimple]  
      render :layout => 'simple'
    end
  end

  def new
    @mediablock = Mediablock.new
    if params[:rendersimple]  
      render :layout => 'simple'
    end
  end

  def create

#    case @request.method
#    when :post
#      @message = 'File uploaded: ' + params[:mediablock][:file].size.to_s

#      upload_progress.message = "Simulating some file processing stage 1..."
#      session.update
#      sleep(2)
      
#      upload_progress.message = "Continuing processing stage 2..."
#      session.update
#      sleep(2)

#      finish_upload_status "'#{@message}'"
#    end

    @mediablock = Mediablock.new(params[:mediablock])
    @mediablock.uploaded_at = DateTime.new(1970, 01, 01, 01, 01).to_s(:db)
    
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
      flash[:notice] = 'Mediablock was successfully created.'
      render :action => 'new'
    end
  end

  def edit
    @mediablock = Mediablock.find(params[:id])
    if params[:rendersimple]  
      render :layout => 'simple'
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
    if session[:current_article]
      redirect_to :controller => '/articles', :action => 'edit', :id => session[:current_article]
    elsif session[:current_gallery]
      redirect_to :controller => '/galleries', :action => 'edit', :id => session[:current_gallery]
    else
      render :nothing => true
    end    
  end
end