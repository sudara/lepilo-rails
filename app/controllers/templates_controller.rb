class TemplatesController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @template_pages, @templates = paginate :templates, :per_page => 10
  end

  def show
    @template = Template.find(params[:id])
  end

  def new
    @template = Template.new
  end

  def create
    @template = Template.new(params[:template])
    if @template.save
      flash[:ok] = 'Template was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @template = Template.find(params[:id])
  end

  def update
    @template = Template.find(params[:id])
    if @template.update_attributes(params[:template])
      flash[:ok] = 'Template was successfully updated.'
      redirect_to :action => 'show', :id => @template
    else
      render :action => 'edit'
    end
  end

  def destroy
    Template.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
