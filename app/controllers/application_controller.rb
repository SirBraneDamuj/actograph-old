class ApplicationController < ActionController::Base
  before_action :_find_user

  def render_not_found
    render :file => "#{Rails.root}/public/404.html",  :status => 404
  end

  def require_login
    puts "hello"
    unless @user.present?
      flash[:alert] = "You must be logged in."
      redirect_to "/login"
    end
    puts "world"
  end

  private

  def _find_user
    @user = User.find(session[:user_id]) if session[:user_id].present?
  end
end
