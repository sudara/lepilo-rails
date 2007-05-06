class GalleriesController < ApplicationController

  before_filter :login_required, :except => [ :show, :showdina4, :simple ]

  def index
    list
    render :action => 'list'
  end

  def list
    @gallery_pages, @galleries = paginate :galleries, :per_page => 12
    if params[:rendersimple]  
      render :layout => 'simple'
    end
  end

  def search
    if !params['criteria'] || 0 == params['criteria'].length
      @items = nil
      render_without_layout
    else
      #@items = Gallery.find(:all, :order => 'updated_at DESC',
      @items = Gallery.find(:all, :order => 'created_at DESC',
        :conditions => [ 'LOWER(title) LIKE ?', 
        '%' + params['criteria'].downcase + '%' ])
      @mark_term = params['criteria']
      render_without_layout
    end
  end

  def addblock
    @gallery = Gallery.find(session[:current_gallery])
    
    drop_type = params[:id].split("_")[0]  
    drop_id = params[:id].split("_")[1]  
    
    if drop_type == "dragarticle"
      addlink = BlockLink.new
      addlink.article_id = drop_id
      addlink.gallery_id = @gallery.id

      if addlink.save
        redirect_to :action => 'edit', :id => @gallery
      end
    end

    if drop_type == "dragmediablock"
      addlink = BlockLink.new
      addlink.mediablock_id = drop_id
      addlink.gallery_id = @gallery.id

      if addlink.save
        redirect_to :action => 'edit', :id => @gallery
      end
    end
        
  end

  def show
    @gallery = Gallery.find(params[:id])
    if params[:rendersimple]  
      render :layout => 'simple'
    end
  end
  
  def showdina4
    @gallery = Gallery.find(params[:id])
    render :layout => false
  end

  def showbestof
    @gallery = Gallery.find_by_title("best of")
    render :layout => false
  end

  def simple
    @gallery = Gallery.find(params[:id])
    render :layout => false
  end

  def new
    @gallery = Gallery.new
    if params[:rendersimple]  
      render :layout => 'simple'
    end
  end

  def create
    @gallery = Gallery.new(params[:gallery])
    if @gallery.save
      flash[:ok] = 'Gallery was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def addmediablock
    @gallery = Gallery.find(params[:id])

    addlink = BlockLink.new
    
    addblock = Mediablock.new
    addblock.title = "Mediablock, #{self.title}"
    addblock.save
    
    addlink.mediablock_id = addblock.id
    addlink.gallery_id = self.id

    if addlink.save
      flash[:ok] = 'Mediablock hinzugef&uuml;gt.'
      redirect_to :action => 'show', :id => @gallery
    else
      render :action => 'list'
    end
  end

  def edit
    @gallery = Gallery.find(params[:id])
    if params[:rendersimple]  
      render :layout => 'simple'
    end
  end

  def sort 
    @gallery = Gallery.find(params[:id]) 
    @gallery.block_links.each do |block| 
      block.position = params[ 'block-list' ].index(block.id.to_s) + 1 
      block.save 
    end 
    render :nothing => true 
  end 

  def update
    @gallery = Gallery.find(params[:id])
    if @gallery.update_attributes(params[:gallery])
      flash[:ok] = "Gallerie #{@gallery.title} aktualisiert."
      redirect_to :action => 'list'
    else
      render :action => 'edit'
    end
  end

  def destroy
    Gallery.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
