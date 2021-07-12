class TitlesController < ApplicationController
  before_action :require_login
  def index
    @movies = Movie.order(:name).all
    @series = TvSeries.order(:name).all
  end

  def new; end

  def create
    type = params[:type]
    id = params[:tmdb_id].to_i
    watched = params[:watched].present?
    case type
    when "movie"
      movie = Movie.find_by(:tmdb_id => id)
      if movie
        redirect_to "/movies/#{id}"
      else
        LoadMovieJob.perform_later(id, watched ? @user.id : nil)
        flash[:notice] = "Loading movie in the background. Please check back later."
        redirect_to :action => "new"
      end
    when "series"
      series = TvSeries.find_by(:tmdb_id => id)
      if series
        redirect_to "/series/#{id}"
      else
        LoadSeriesJob.perform_later(id, watched ? @user.id : nil)
        flash[:notice] = "Loading series in the background. Please check back later."
        redirect_to :action => "new"
      end
    end
  end
end
