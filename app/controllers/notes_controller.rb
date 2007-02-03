class NotesController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  def list
    @note_pages, @notes = paginate :notes, :per_page => 10
    if params[:rendersimple] = "true" 
      render :layout => "simple"
    end
  end

  def show
    @note = Note.find(params[:id])
    if params[:rendersimple] = "true" 
      render :layout => "simple"
    end
  end

  def new
    @note = Note.new
    if params[:rendersimple] = "true" 
      render :layout => "simple"
    end
  end

  def create
    @note = Note.new(params[:note])
    if @note.save
      flash[:notice] = 'Note was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @note = Note.find(params[:id])
    if params[:rendersimple] = "true" 
      render :layout => "simple"
    end
  end

  def update
    @note = Note.find(params[:id])
    if @note.update_attributes(params[:note])
      flash[:notice] = 'Note was successfully updated.'
      redirect_to :action => 'show', :id => @note
    else
      render :action => 'edit'
    end
  end

  def destroy
    Note.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
