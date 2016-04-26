class SessionsController < ApplicationController

  def new
    flash.clear()
  end

  def create
  	user = User.find_by_email(params.require(:email))
    if user && user.authenticate(params.require(:password))
      session[:user_id] = user.id
      redirect_to root_url, flash: {:success => "Logged in!"}
    else
      flash.now['alert alert-danger'] = "Invalid email or password"
      render "new"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, flash: {'alert alert-success' => "Logged out!"}
  end

end
