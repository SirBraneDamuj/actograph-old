class HomeController < ApplicationController
  def index
    @total_titles = Movie.count + TvSeries.count
  end
end
