class UsersController < ApplicationController

  before_filter :login_required, :except => [:new]
  before_filter :find_user,      :only =>   [:edit, :update, :destroy, :admin]
  
  def index
    respond_to do |format|
      format.html do
        @users = User.paginate :page => params[:page]
        @user_count = User.count
      end
      format.xml do
        @users = User.search(params[:q], :limit => 25)
        render :xml => @users.to_xml
      end
    end
  end

  def show
    respond_to do |format|
      format.html
      format.xml { render :xml => @user.to_xml }
    end
  end
  
  def edit
  end
  
  # only lepilo admins can create 
  def new
    redirect_to login_path if User.count > 0 and !current_user.admin?
  end

  def create
    @user = User.new(params[:user])
    @user.save!
    self.current_user = @user
    redirect_back_or_default(users_path)
    flash[:notice] = "Thanks for signing up!"
  rescue ActiveRecord::RecordInvalid
    render :action => 'new'
  end

  def admin
    respond_to do |format|
      format.html do
        @user.admin = params[:user][:admin] == '1'
        @user.save
        redirect_to user_path(@user)
      end
    end
  end

  def update
    if @user.update_attributes(params[:user])
      flash[:notice] = 'User was successfully updated.'
      redirect_to users_path
    else
      render :action => "edit" 
    end  
  end
  
  
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_path }
      format.xml  { head 200 }
    end
  end
  
  protected
    def authorized?
      # This means admins can do everything, 
      # users can update their profile,
      # not logged in folks can't do jack
      admin? || (!%w(destroy admin index).include?(action_name) && (params[:id].nil? || params[:id] == current_user.id.to_s))
    end
    
    def find_user
      @user = User.find_by_id(params[:id]) 
    end
end
