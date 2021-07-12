class ActorsController < ApplicationController
  before_action :require_login

  def index
    @offset = params[:offset]&.to_i || 0
    @actors = Actor.order(:name).limit(25).offset(@offset)
  end

  def show
    @actor = Actor.find(params[:tmdb_id].to_i)
  end
end

