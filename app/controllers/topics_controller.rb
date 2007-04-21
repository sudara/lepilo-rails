class TopicsController < ApplicationController

  before_filter :login_required, :except => [ :show, :simple ]

  def index
    list
    render :action => 'list'
  end

  def list
    @topic_pages, @topics = paginate :topics, :per_page => 75
    if params[:rendersimple]  
      render :layout => 'simple'
    end
  end

  def show
    @topic = Topic.find(params[:id])
    if params[:rendersimple]  
      render :layout => 'simple'
    end
  end

  def simple
    @topics = Topic.find_all_by_topic_id(1)
    render :layout => false
  end

  def new
    @topic = Topic.new
    if params[:rendersimple]  
      render :layout => 'simple'
    end
  end

  def create
    @topic = Topic.new(params[:topic])
    if @topic.save
      flash[:notice] = 'Topic was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @topic = Topic.find(params[:id])
    if params[:rendersimple]  
      render :layout => 'simple'
    end
  end
  
  def topic_changed
    render :partial => "subtopics", :locals => { :topic_id => @params[:id]}
  end 
  
  def subtopic_changed
    render :partial => "subsubtopics", :locals => { :topic_id => @params[:id]}
  end

  def subsubtopic_changed
    # render :partial => "subsubsubtopics", :locals => { :topic_id => @params[:id]}
  end
  
  
  def sort 
    @topic = Topic.find(params[:id]) 
    @topic.topics.each do |subtopics| 
      subtopics.position = params[ 'lpltopic-list' ].index(subtopics.id.to_s) + 1 
      subtopics.save 
    end 
    render :nothing => true 
  end 
  
  def update
    @topic = Topic.find(params[:id])
    if @topic.update_attributes(params[:topic])
      flash[:notice] = 'Topic was successfully updated.'
      redirect_to :action => 'list', :id => @topic
    else
      render :action => 'edit'
    end
  end

  def destroy
    Topic.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
