class NotesController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  def list
    if !params['criteria'] || 0 == params['criteria'].length
      @note_pages, @notes = paginate :notes, :per_page => 25
    else
      @notes = Note.find(:all, :order => 'updated_at DESC',
        :conditions => [ 'LOWER(title) LIKE ?', 
        '%' + params['criteria'].downcase + '%' ])
      @mark_term = params['criteria']
      render_without_layout
    end
    

    if params[:rendersimple] == "true" 
      render :layout => 'simple'
    end
  end

  def show
    @note = Note.find(params[:id])
    if params[:rendersimple] == "true" 
      render :layout => 'simple'
    end
  end

  def new
    @note = Note.new
    if params[:rendersimple] == "true" 
      render :layout => 'simple'
    end
  end

  def create
    @note = Note.new(params[:note])
    @note.released = 0
    
    if @note.save
      flash[:ok] = 'Note was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @note = Note.find(params[:id])
    if params[:rendersimple] == "true" 
      render :layout => 'simple'
    end
  end

  def update
    @note = Note.find(params[:id])
    if @note.update_attributes(params[:note])
      flash[:ok] = 'Note was successfully updated.'
      redirect_to :action => 'show', :id => @note
    else
      render :action => 'edit'
    end
  end

  def destroy
    Note.find(params[:id]).destroy
    flash[:ok] = 'Note was successfully destroyed.'
    redirect_to :action => 'list'
  end
end
