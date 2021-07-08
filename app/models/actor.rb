class Actor
  include ActiveGraph::Node

  id_property :tmdb_id
  property :name
  property :profile_path

  has_many :out, :episode_appearances, :rel_class => :StarredInEpisode
  has_many :out, :movie_appearances, :rel_class => :StarredInMovie
end
