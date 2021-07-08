class SeriesController < ApplicationController
  def index
    @offset = params[:offset]&.to_i || 0
    @series = TvSeries.order(:name).limit(25).offset(@offset)
  end

  def show
    tmdb_id = params[:tmdb_id]
    @series = TvSeries.find(tmdb_id.to_i)
  end
end
