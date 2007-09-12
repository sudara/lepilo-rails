class AccountController < ApplicationController
  layout  'login'

  # before_filter :login_required, :except => [ :login ]

  def index
    render :action => 'login'
  end

  def login
    redirect_to :action => "signup" if @session[:user].nil? && User.count == 0
    case @request.method
      when :post
        if @session['user'] = User.authenticate(params['user_login'], params['user_password'])

          flash[:ok]  = "Login successful"
          redirect_back_or_default :action => "welcome"
        else
          @login    = params['user_login']
          @message  = "Login unsuccessful"
      end
    end
  end
  
  def signup
    redirect_to :action => "login" if @session[:user].nil? && User.count != 0
    case @request.method
      when :post
        @user = User.new(params['user'])
      
        if @user.save      
          @session['user'] = User.authenticate(@user.login, params['user']['password'])
          flash[:ok]  = "Signup successful"
          # redirect_back_or_default :action => "welcome"          
          redirect_to :controller=>"/articles", :action =>"index"
        end
      when :get
        @user = User.new
    end      
  end  
  
  def delete
    if @session[:user].nil? && usercount != 0
      redirect_to :action => "login" 
    else
      if params['id']
        @user = User.find(params['id'])
        @user.destroy
      end
    end
    redirect_back_or_default :action => "welcome"
  end  
    
  def logout
    @session['user'] = nil
  end
    
  def welcome
  end
  
end
