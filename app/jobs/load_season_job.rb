class LoadSeasonJob < ApplicationJob
  queue_as :default

  def perform(series_id, season_number)
    Tmdb.load_season(series_id, season_number, nil, nil)
  end
end
