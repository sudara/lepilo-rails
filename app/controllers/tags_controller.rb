class TagsController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  def list
    @tag_pages, @tags = paginate :tags, :per_page => 10
    if params[:rendersimple] == "true" 
      render :layout => 'simple'
    end
  end

  def show
    @tag = Tag.find(params[:id])
    if params[:rendersimple] == "true" 
      render :layout => 'simple'
    end
  end

  def new
    @tag = Tag.new
    if params[:rendersimple] == "true" 
      render :layout => 'simple'
    end
  end

  def create
    @tag = Tag.new(params[:tag])
    if @tag.save
      flash[:ok] = 'Tag was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @tag = Tag.find(params[:id])
    if params[:rendersimple] == "true" 
      render :layout => 'simple'
    end
  end

  def update
    @tag = Tag.find(params[:id])
    if @tag.update_attributes(params[:tag])
      flash[:ok] = 'Tag was successfully updated.'
      redirect_to :action => 'show', :id => @tag
    else
      render :action => 'edit'
    end
  end

  def destroy
    Tag.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
