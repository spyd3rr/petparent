class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.authenticate(params[:username], params[:password])
    if user
      if user.role != "admin"
        flash.now.alert = "Only admin users accessible"
        render "new"
      else
        session[:user_id] = user.id
        redirect_to venues_url, :notice => "logged in successfully!"
      end
    else
      flash.now.alert = "Invalid username or password"
      render "new"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, :notice => "Logged out!"
  end

end