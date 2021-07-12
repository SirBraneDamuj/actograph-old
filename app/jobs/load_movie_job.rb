class LoadMovieJob < ApplicationJob
  queue_as :default

  def perform(movie_id, user_id)
    Tmdb.load_movie(movie_id, user_id)
  end
end
