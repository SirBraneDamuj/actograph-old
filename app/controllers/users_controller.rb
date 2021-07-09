class UsersController < ApplicationController
  def new
    @model = User.new
  end

  def create
    @model = User.new(_user_params)
    unless @model.save
      flash[:alert] = "Something's wrong... I can feel it."
      render :new
    else
      redirect_to "/home"
    end
  end

  def login; end

  def do_login
    user = User.find_by(name: params[:name])
    unless user && user.authenticate(params[:password])
      flash[:alert] = "Invalid credentials"
      render :login
    else
      session[:user_id] = user.id
      redirect_to "/home"
    end
  end

  def logout
    session[:user_id] = nil
    redirect_to "/home"
  end

  private

  def _user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
