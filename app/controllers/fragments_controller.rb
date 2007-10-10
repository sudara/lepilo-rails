class FragmentsController < ApplicationController

  before_filter :login_required, :except => [ :show ]

  def index
    list
    render :action => 'list'
  end

  def list
    @fragment_pages, @fragments = paginate :fragments, :per_page => 25

  end

  def show
    @fragment = Fragment.find(params[:id])

  end

  def new
    @fragment = Fragment.new

  end

  def create
    @fragment = Fragment.new(params[:fragment])
    if @fragment.save
      flash[:ok] = 'Fragment was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @fragment = Fragment.find(params[:id])

  end

  def update
    @fragment = Fragment.find(params[:id])
    if @fragment.update_attributes(params[:fragment])
      flash[:ok] = 'Fragment was successfully updated.'
      redirect_to :action => 'show', :id => @fragment
    else
      render :action => 'edit'
    end
  end

  def destroy
    Fragment.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end