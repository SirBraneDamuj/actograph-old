class TvSeason
  include ActiveGraph::Node

  id_property :tmdb_id
  property :season_number
  property :poster_path

  has_many :in, :episodes, :type => :episode_of, :model_class => 'TvEpisode', :dependent => :destroy
  has_one :out, :series, :type => :season_of, :model_class => 'TvSeries'
end
