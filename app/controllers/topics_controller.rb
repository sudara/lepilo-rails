class TopicsController < ApplicationController

  before_filter :login_required, :except => [ :show, :simple ]

  Topic.content_columns.each do |column| 
    in_place_edit_for :topic, column.name 
  end 

  def index
    list
  end

  def list
    @topics = Topic.find_all_by_topic_id(params[:topic_id] || 1) 
    @parent = Topic.find(params[:topic_id] || 1) 
    @level = @parent.level 
    
    respond_to do |format|
      format.html
      format.js 
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
    @topic = Topic.new(:topic_id => params[:topic_id])
    flash[:ok] = 'Topic was successfully created.' if @topic.save

    respond_to do |format|
      format.html
      format.js
    end
  end

  def edit
    @topic = Topic.find(params[:id])
    @topic.description.length < 2
      @topic.description = '...'
    if params[:rendersimple]  
      render :layout => 'simple'
    end
  end
  
  def topic_changed
    current_topic  = Topic.find(params[:id])
    current_parent = Topic.find_by_topic_id(params[:id])
    render :partial => "selector", :locals => { :current_topic => current_topic, :current_parent => current_parent }
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
      flash[:ok] = 'Topic was successfully updated.'
      redirect_to :action => 'index', :id => @topic
    else
      render :action => 'edit'
    end
  end

  def destroy
    killtopic = Topic.find(params[:id])
    killedtopic = killtopic.title
    killtopic.destroy
    flash[:warning] = 'Topic ' + killedtopic + ' was destroyed!'
    redirect_to :action => 'index'
  end
end
