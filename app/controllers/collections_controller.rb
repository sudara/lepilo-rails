class CollectionsController < ApplicationController
  #blah
  before_filter :login_required, :except => [ :show, :showdina4, :simple ]

  def index
    list
    render :action => 'list'
  end

  def list
    @collection_pages, @collections = paginate :collections, :per_page => 12
    if params[:rendersimple]  
      render :layout => 'simple'
    end
  end

  def search
    if !params['criteria'] || 0 == params['criteria'].length
      @items = nil
      render_without_layout
    else
      #@items = Collection.find(:all, :order => 'updated_at DESC',
      @items = Collection.find(:all, :order => 'created_at DESC',
        :conditions => [ 'LOWER(title) LIKE ?', 
        '%' + params['criteria'].downcase + '%' ])
      @mark_term = params['criteria']
      render_without_layout
    end
  end

  def addblock
    @collection = Collection.find(session[:current_collection])
    
    drop_type = params[:id].split("_")[0]  
    drop_id = params[:id].split("_")[1]  
    
    if drop_type == "dragarticle"
      addlink = BlockLink.new
      addlink.article_id = drop_id
      addlink.collection_id = @collection.id

      if addlink.save
        redirect_to :action => 'edit', :id => @collection
      end
    end

    if drop_type == "dragmediablock"
      addlink = BlockLink.new
      addlink.mediablock_id = drop_id
      addlink.collection_id = @collection.id

      if addlink.save
        redirect_to :action => 'edit', :id => @collection
      end
    end
        
  end

  def show
    @collection = Collection.find(params[:id])
    if params[:rendersimple]  
      render :layout => 'simple'
    end
  end
  
  def showdina4
    @collection = Collection.find(params[:id])
    render :layout => false
  end

  def showbestof
    @collection = Collection.find_by_title("best of")
    render :layout => false
  end

  def simple
    @collection = Collection.find(params[:id])
    render :layout => false
  end

  def new
    @collection = Collection.new
    if params[:rendersimple]  
      render :layout => 'simple'
    end
  end

  def create
    @collection = Collection.new(params[:collection])
    if @collection.save
      flash[:ok] = 'Collection was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def addmediablock
    @collection = Collection.find(params[:id])

    addlink = BlockLink.new
    
    addblock = Mediablock.new
    addblock.title = "Mediablock, #{self.title}"
    addblock.save
    
    addlink.mediablock_id = addblock.id
    addlink.collection_id = self.id

    if addlink.save
      flash[:ok] = 'Mediablock hinzugef&uuml;gt.'
      redirect_to :action => 'show', :id => @collection
    else
      render :action => 'list'
    end
  end

  def edit
    @collection = Collection.find(params[:id])
    if params[:rendersimple]  
      render :layout => 'simple'
    end
  end

  def sort 
    @collection = Collection.find(params[:id]) 
    @collection.block_links.each do |block| 
      block.position = params[ 'block-list' ].index(block.id.to_s) + 1 
      block.save 
    end 
    render :nothing => true 
  end 

  def update
    @collection = Collection.find(params[:id])
    if @collection.update_attributes(params[:collection])
      flash[:ok] = "Gallerie #{@collection.title} aktualisiert."
      redirect_to :action => 'list'
    else
      render :action => 'edit'
    end
  end

  def destroy
    Collection.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
