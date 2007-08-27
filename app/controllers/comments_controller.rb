class CommentsController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  def list    
    @comment_pages, @comments = paginate :comments, :per_page => 25
    if params[:rendersimple] == "true" 
      render :layout => 'simple'
    end
  end

  def show
    @comment = Comment.find(params[:id])
    if params[:rendersimple] == "true" 
      render :layout => 'simple'
    end
  end

  def new
    @comment = Comment.new
    if params[:rendersimple] == "true" 
      render :layout => 'simple'
    end
  end

  def create
    @comment = Comment.new(params[:comment])
    if @comment.save
      flash[:ok] = 'Comment was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @comment = Comment.find(params[:id])
    if params[:rendersimple] == "true" 
      render :layout => 'simple'
    end
  end

  def update
    @comment = Comment.find(params[:id])
    if @comment.update_attributes(params[:comment])
      flash[:ok] = 'Comment was successfully updated.'
      redirect_to :action => 'show', :id => @comment
    else
      render :action => 'edit'
    end
  end

  def destroy
    Comment.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
