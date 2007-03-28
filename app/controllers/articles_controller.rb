class ArticlesController < ApplicationController

  before_filter :login_required, :except => [ :show, :showswf, :showdina4, :simple ]

  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  #verify :method => :post, :only => [ :destroy, :create, :update ],
  #       :redirect_to => { :action => :list }

  def list
    @article_pages, @articles = paginate :articles, :order => 'release_date DESC, reference DESC', :per_page => 16
    
    if params[:rendersimple]  
      render :layout => "simple"
    end
  end

  def search
    if !@params['criteria'] || 0 == @params['criteria'].length
      @items = nil
      render_without_layout
    else
      @items = Article.find(:all, :order => 'updated_at DESC',
        :conditions => [ 'LOWER(title) LIKE ?', 
        '%' + @params['criteria'].downcase + '%' ])
      @mark_term = @params['criteria']
      render_without_layout
    end
  end

  def thumbnail
    drop_type = params[:id].split("_")[0]  
    drop_id = params[:id].split("_")[1]  
    
    if drop_type == "item"
      findblock = BlockLink.find(drop_id)
      thumb_id = findblock.mediablock_id
      updatethumb = Article.find(session[:current_article])
      updatethumb.thumbnail_id = thumb_id
      updatethumb.save
      @thumbnail = Mediablock.find(thumb_id)
    else
      updatethumb = Article.find(session[:current_article])
      updatethumb.thumbnail_id = drop_id
      updatethumb.save
      @thumbnail = Mediablock.find(drop_id)
    end
        
    render_without_layout
  end

  def addblock
    @article = Article.find(session[:current_article])
    
    drop_type = params[:id].split("_")[0]  
    drop_id = params[:id].split("_")[1]  
    
    if !params['fragment']
      drop_into_fragment = @article.fragments.find_by_content("web").id
    else
      drop_into_fragment = @article.fragments.find_by_content(params['fragment']).id
    end
        
    if drop_type == "dragarticle"
      addlink = BlockLink.new
      addlink.article_id = drop_id
      addlink.fragment_id = drop_into_fragment

      if addlink.save
        redirect_to :action => 'edit', :id => @article, :fragment => params['fragment']
      end
    end

    if drop_type == "draggallery"
      addlink = BlockLink.new
      addlink.gallery_id = drop_id
      addlink.fragment_id = drop_into_fragment

      if addlink.save
        redirect_to :action => 'edit', :id => @article, :fragment => params['fragment']
      end
    end

    if drop_type == "dragmediablock"
      addlink = BlockLink.new
      addlink.mediablock_id = drop_id
      addlink.fragment_id = drop_into_fragment

      if addlink.save
        redirect_to :action => 'edit', :id => @article, :fragment => params['fragment']
      end
    end

    if drop_type == "dragtextblock"
      addlink = BlockLink.new
      addlink.textblock_id = drop_id
      addlink.fragment_id = drop_into_fragment

      if addlink.save
        redirect_to :action => 'edit', :id => @article, :fragment => params['fragment']
      end
    end
        
                  
  end


  def show
    @article = Article.find(params[:id])
    if params[:rendersimple]  
      render :layout => "simple"
    end
  end

  def showswf
    @article = Article.find(params[:id])
    render :layout => "simple"
  end

  def showdina4
    @articles = Article.find(:all, :order => 'release_date DESC', :conditions => "released = 1")
    render :layout => false
  end

  def writexml
    @articles = Article.find(:all, :order => 'release_date DESC', :conditions => "released = 1")
    # render :layout => false
    projectsxml = render_to_string :layout => false
    timestamp = Time.now.to_i.to_s
    
    if File.exists?("#{RAILS_ROOT}/public/projekte.xml")
      File.open("#{RAILS_ROOT}/public/data/backups/projekte-#{timestamp}.xml", "wb") do |f|
        f.write( File.read("#{RAILS_ROOT}/public/projekte.xml") )
      end        
    end
    
    File.open("#{RAILS_ROOT}/public/projekte.xml", "wb") do |f|
      f.write( projectsxml )
    end

    redirect_to :action => 'list'
  end

  def simple
    @article = Article.find_by_topic_id(params[:id])
    render :layout => false
  end

  def import
    if params[:importdir]  
      @article = Article.new
      articledata = params[:importdir].split('_')
      #@article.reference = articledata[0][2,articledata[0].length]
      @article.reference = articledata[0]
      
      yearstamp = articledata[0][0,2]
      if (yearstamp[0,1] == "9")
        year = "19" << yearstamp
      else
        year = "20" << yearstamp
      end
      @article.release_date = year << "-01-01"
      
      @article.title = articledata[1]
      @article.topic_id = 4
      
      @article.save
      @article.update
      
      #"public/data/import/"
#      importfrom = Dir.new(params[:importdir]) 
#      importfrom.each  do |file| 
        
#      end
      
    end
  end

  def new
    @article = Article.new
    if params[:rendersimple]  
      render :layout => "simple"
    end
  end

  def create
    @article = Article.new(params[:article])
    @article.release_date = Date.today
    
    if @article.save
      flash[:notice] = 'Article was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def addtextblock
    @article = Article.find(params[:id])

    addlink = BlockLink.new
    
    addblock = Textblock.new
    addblock.title = "Textblock, #{@article.title}"
    
    addlink.textblock_id = addblock.id
    addlink.save

    addblock.save
    
    if addlink.save
      flash[:notice] = 'Textblock hinzugef&uuml;gt.'
      redirect_to :action => 'show', :id => self.id
    else
      render :action => 'list'
    end
  end
  
  
  def addmediablock
    @article = Article.find(params[:id])

    addlink = BlockLink.new
    
    addblock = Mediablock.new
    addblock.title = "Mediablock, #{self.title}"
    addblock.save
    
    addlink.textblock_id = addblock.id
    addlink.fragment_id = addblock.id
    

    if addlink.save
      flash[:notice] = 'Mediablock hinzugef&uuml;gt.'
      redirect_to :action => 'show', :id => @article
    else
      render :action => 'list'
    end
  end
  
  def imagedescriptions
    @article = Article.find(params[:id])
    fragmentno = @article.fragments.first.id
    @mediablocklist = BlockLink.find_all_by_fragment_id(fragmentno)

    for blocklink in @mediablocklist
      if blocklink.mediablock_id != nil
        image = Mediablock.find_by_id(blocklink.mediablock_id)
        image.description = params[:description]
        image.update
      end
    end 

    redirect_to :action => 'edit', :id => @article
  end
  
  def edit
    @article = Article.find(params[:id])
    
   # if test != Fragment.find_by_article_id_and_content(:article_id => @article.id, :content => "print")
  #    @articlePrintFragment = Fragment.new
  #    @articlePrintFragment.article_id = self.id
  #    @articlePrintFragment.info = "Print PDF for #{self.title}"
  #    @articlePrintFragment.content = "print"
  #    @articlePrintFragment.save
  #    @articlePrintFragment.update
  #  end
    
    if params[:rendersimple]  
      render :layout => "simple"
    end
  end

  def sort 
    @article = Article.find(params[:id])
    @article.fragments.first.block_links.each do |block| 
      block.position = params[ 'block-list' ].index(block.id.to_s) + 1 
      block.save 
    end 
    render :nothing => true 
  end 

  def update
    @article = Article.find(params[:id])
    if @article.update_attributes(params[:article])
      flash[:notice] = "Artikel #{@article.title} aktualisiert."
      redirect_to :action => 'list', :page => session[:current_page]
    else
      render :action => 'edit'
    end
  end

  def destroy
    Article.find(params[:id]).destroy
    redirect_to :action => 'list'
  end

  def destroylink
    BlockLink.find(params[:id]).destroy
    redirect_to :controller => '/galleries', :action => 'edit', :id => session[:current_gallery]
  end
end
