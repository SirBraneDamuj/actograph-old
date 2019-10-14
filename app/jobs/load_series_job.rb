class LoadSeriesJob < ApplicationJob
  queue_as :default

  def perform(series_id)
    Tmdb.load_series(series_id)
  end
end
