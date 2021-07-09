class User
  include ActiveGraph::Node

  property :name
  property :hashed_password

  has_many :out, :watched_episodes, :type => :watched, :model_class => 'TvEpisode'
  has_many :out, :watched_movies, :type => :watched, :model_class => 'TvEpisode'
end
