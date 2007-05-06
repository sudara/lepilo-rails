class AccountController < ApplicationController
  model   :user
  layout  'login'

  # before_filter :login_required, :except => [ :login ]

  def login
    usercount = User.count
    if @session[:user].nil? && usercount == 0
      redirect_to :action => "signup" 
    else
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
  end
  
  def signup
    
    usercount = User.count
    if @session[:user].nil? && usercount != 0
      redirect_to :action => "login" 
    else
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
