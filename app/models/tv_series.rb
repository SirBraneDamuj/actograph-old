class TvSeries
  include Neo4j::ActiveNode

  id_property :tmdb_id
  property :name
  property :poster_path

  has_many :in, :seasons, :type => :season_of, :model_class => 'TvSeason'
end
