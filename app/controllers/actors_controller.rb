class ActorsController < ApplicationController
  def show
    @actor = Actor.find(params[:tmdb_id].to_i)
  end
end

