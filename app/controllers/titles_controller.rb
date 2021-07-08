class TitlesController < ApplicationController
  def index
    @movies = Movie.order(:name).all
    @series = TvSeries.order(:name).all
  end

  def new; end

  def create
    type = params[:type]
    id = params[:tmdb_id]
    case type
    when "movie"
      LoadMovieJob.perform_later(id)
    when "series"
      LoadSeriesJob.perform_later(id)
    when "season"
      LoadSeasonJob.perform_later(id, params[:season_number])
    end
    redirect_to :action => "new"
  end
end
