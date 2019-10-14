class TitlesController < ApplicationController
  def index
    @movies = Movie.order(:name).all
    @series = TvSeries.order(:name).all
  end

  def show

  end
end
