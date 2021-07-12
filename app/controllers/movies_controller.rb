class MoviesController < ApplicationController
  before_action :require_login
  before_action :_find_movie, :only => [:show, :watch, :unwatch]

  def index
    @offset = params[:offset]&.to_i || 0
    @watched = params[:watched] == "true"
    if @watched
      all_movies = @user.watched_movies.order(:name)
      @count = all_movies.count
      @movies = all_movies.limit(25).offset(@offset)
    else
      all_movies = Movie.order(:name)
      @count = all_movies.count
      @movies = Movie.limit(25).offset(@offset)
    end
    @min = @offset + 1
    @max = (@offset + 25) > @count ? @count : (@offset + 25)
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
      flash[:alert] = "Failed to Unwatch movie."
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
