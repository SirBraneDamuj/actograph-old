class TvEpisode
  include Neo4j::ActiveNode

  id_property :tmdb_id
  property :name
  property :episode_number

  has_many :in, :cast_members, :type => :starred_in, :model_class => 'Actor'
  has_one :out, :season, :type => :in_season, :model_class => 'TvSeason'
end
