class Movie
  include Neo4j::ActiveNode

  id_property :tmdb_id
  property :name
  property :backdrop_path

  has_many :in, :cast_members, :type => :starred_in, :model_class => 'Actor'
end
