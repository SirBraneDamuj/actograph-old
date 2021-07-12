class User
  include ActiveGraph::Node
  include ActiveModel::SecurePassword

  has_secure_password

  property :name, type: String
  property :email, type: String
  property :password_digest, type: String

  has_many :out, :watched_episodes, :type => :watched, :model_class => 'TvEpisode'
  has_many :out, :watched_movies, :type => :watched, :model_class => 'Movie'

  def watched_movie?(tmdb_id)
    watched_movies.find_by(:tmdb_id => tmdb_id).present?
  end

  def watched_episode?(tmdb_id, season_number, episode_number)
    TvSeries
      .where(tmdb_id: tmdb_id)
      .seasons
      .where(season_number: season_number)
      .episodes
      .where(episode_number: episode_number)
      .watchers
      .where(uuid: uuid)
      .exists?
  end
end
