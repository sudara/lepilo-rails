# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController

  layout  'login'
  
  # render new.rhtml
  def new
    redirect_to new_user_path if User.count < 1
  end

  def create
    self.current_user = User.authenticate(params[:login], params[:password])
    if logged_in?
      if params[:remember_me] == "1"
        self.current_user.remember_me
        cookies[:auth_token] = { :value => self.current_user.remember_token , :expires => self.current_user.remember_token_expires_at }
      end
      redirect_to :controller => :settings
      flash[:ok] = "Logged in successfully"
    else
      flash[:error] = "Login or Password incorrect!"
      render :action => 'new'
    end
  end

  def destroy
    self.current_user.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    flash[:ok] = "You have been logged out."
    redirect_back_or_default('/sessions/new')
  end
end
