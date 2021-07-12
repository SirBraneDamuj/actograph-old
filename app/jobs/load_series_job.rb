class LoadSeriesJob < ApplicationJob
  queue_as :default

  def perform(series_id, user_id)
    Tmdb.load_series(series_id, user_id)
  end
end
