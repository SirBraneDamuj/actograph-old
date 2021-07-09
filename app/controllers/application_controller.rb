class ApplicationController < ActionController::Base
  before_action :_find_user

  def render_not_found
    render :file => "#{Rails.root}/public/404.html",  :status => 404
  end

  private

  def _find_user
    @user = User.find(session[:user_id]) if session[:user_id].present?
  end
end
