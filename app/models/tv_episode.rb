class TvEpisode
  include Neo4j::ActiveNode

  id_property :tmdb_id
  property :name
  property :episode_number

  has_many :in, :cast_members, :rel_class => :StarredInEpisode
  has_one :out, :season, :type => :episode_of, :model_class => 'TvSeason'
end
