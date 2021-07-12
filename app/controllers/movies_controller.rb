class MoviesController < ApplicationController
  before_action :require_login
  before_action :_find_movie, :only => [:show, :watch, :unwatch]

  def index
    @offset = params[:offset]&.to_i || 0
    @watched = params[:watched] == "true"
    if @watched
      @movies = @user.watched_movies.order(:name).limit(25).offset(@offset)
    else
      @movies = Movie.order(:name).limit(25).offset(@offset)
    end
  end

  def show; end

  def watch
    @user.watched_movies << @movie
    unless @user.save
      flash[:alert] = "Failed to mark movie as Watched"
    else
      flash[:notice] = "#{@movie.name} is now Watched."
    end
    redirect_to "/movies/#{@tmdb_id}"
  end

  def unwatch
    @user.watched_movies.delete(@movie)
    unless @user.save
      flash[:alert] = "Failed to mark movie as Not Watched"
    else
      flash[:notice] = "#{@movie.name} is now Not Watched."
    end
    redirect_to "/movies/#{@tmdb_id}"
  end

  private

  def _find_movie
    @tmdb_id = params[:tmdb_id].to_i
    @movie = Movie.find_by(:tmdb_id => @tmdb_id)
    unless @movie
      flash[:alert] = "Movie #{@tmdb_id} not found"
      redirect_to "/movies"
    end
  end
end
