class MoviesController < ApplicationController
  def index
    @offset = params[:offset]&.to_i || 0
    @movies = Movie.order(:name).limit(25).offset(@offset)
  end

  def show
    @movie = Movie.find(params[:tmdb_id].to_i)
  end
end
