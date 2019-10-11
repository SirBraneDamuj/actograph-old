class TitlesController < ApplicationController
  def index
    @movies = Movie.all
    @series = TvSeries.all
  end

  def show

  end
end
