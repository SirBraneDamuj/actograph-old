class Movie
  include ActiveGraph::Node

  id_property :tmdb_id
  property :name
  property :poster_path

  has_many :in, :cast_members, :rel_class => :StarredInMovie
end
