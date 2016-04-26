class UsersController < ApplicationController
  # Comment in to avoid users are able to create a login
  # before_action :user_must_be_logged_in!

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to root_url, flash: {'alert alert-success' => "Signed up!"}
    else
      flash.now['alert alert-danger'] = "Could not create user"
      render "new"
    end
  end

  def index
  	@users = User.all
  end

  private

  def user_params
  	params.require(:user).permit(:email, :password, :password_confirmation)
  end
  
end
