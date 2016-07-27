class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  #before_filter :set_cache_headers

  rescue_from User::NotAuthorized, with: :user_not_authorized

  private
  
  helper_method :logged_in?, :user_must_be_logged_in!

  def logged_in?
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  
  def user_must_be_logged_in!
  	raise User::NotAuthorized unless logged_in?
  end

  def user_not_authorized
    render plain: "401 Not Authorized", status: 401
  end

  #def set_cache_headers
  #  response.headers["Cache-Control"] = "no-store"
  #end
end
