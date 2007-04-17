  class ArticlesController < ApplicationController

  before_filter :login_required, :except => [ :show, :showswf, :showdina4, :simple ]

  Article.content_columns.each do |column| 
    in_place_edit_for :article, column.name 
  end 

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
      render :layout => 'simple'
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
    
    if params[:dropfragment_id]
      drop_into_fragment = params[:dropfragment_id]
    elsif params[:fragment]
      drop_into_fragment = @article.fragments.find_by_content(params[:fragment]).id
    else
      drop_into_fragment = @article.fragments.find_by_content("web").id
    end
            
    addlink = BlockLink.new unless addlink = BlockLink.find_by_fragment_id_and_position(drop_into_fragment, params['position'])
    addlink.fragment_id = drop_into_fragment

    case drop_type
      when "dragtextblock"
        addlink.textblock_id = drop_id
      when "dragmediablock"
        addlink.mediablock_id = drop_id
      when "draggallery"
      addlink.gallery_id = drop_id
      when "dragarticle"
      addlink.article_id = drop_id
    end

    if params['position']
      addlink.update
      addlink.position = params['position']
    end
    addlink.save

    if params[:dropfragment_id]
      redirect_to :action => 'edit', :id => @article, :fragment => Fragment.find(params['dropfragment_id']).content
    elsif params[:fragment]
      redirect_to :action => 'edit', :id => @article, :fragment => params['fragment']                
    else
      redirect_to :action => 'edit', :id => @article                
    end
  end


  def show
    @article = Article.find(params[:id])
    if params[:rendersimple]  
      render :layout => 'simple'
    end
  end

  def showswf
    @article = Article.find(params[:id])
    render :layout => 'simple'
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
  
  def writeindesignxml
    @article = Article.find(params[:id])
    indesignxml = render_to_string :layout => false
    timestamp = Time.now.to_i.to_s
    
    if File.exists?("#{RAILS_ROOT}/public/indesign.xml")
      File.open("#{RAILS_ROOT}/public/data/backups/indesign-#{timestamp}.xml", "wb") do |f|
        f.write( File.read("#{RAILS_ROOT}/public/projekte.xml") )
      end        
    end
    
    File.open("#{RAILS_ROOT}/public/indesign.xml", "wb") do |f|
      f.write( indesignxml )
    end

    send_file "#{RAILS_ROOT}/public/indesign.xml"
  end
  
  def getindesignfile
    send_file "#{RAILS_ROOT}/public/a4-xml-import.indd"
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
      @article.released = 0
      
      @article.title = articledata[1]
      @article.topic_id = 4
      
      @article.save
      @article.update      
    end
  end

  def new
    @article = Article.new
    if params[:rendersimple]  
      render :layout => 'simple'
    end
  end

  def create
    @article = Article.new(params[:article])
    if params[:article][:title] == ""
      @article.title = "Noname"
    end
    
    @article.release_date = Date.today
    @article.released = 0
    
    if @article.save
      flash[:notice] = 'Article was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
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
    
    if !test = Fragment.find_by_article_id_and_content(params[:id], "print")
      @articlePrintFragment = Fragment.new
      @articlePrintFragment.article_id = @article.id
      @articlePrintFragment.info = "Print PDF for #{@article.title}"
      @articlePrintFragment.content = "print"
      @articlePrintFragment.save
      @articlePrintFragment.update
    end
    
    if params[:rendersimple]  
      render :layout => 'simple'
    end
  end

  def sort 
    @sortfragment = Fragment.find(params[:sortfragment_id])
    @sortfragment.block_links.each do |block| 
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
