class LoadMovieJob < ApplicationJob
  queue_as :default

  def perform(movie_id)
    puts movie_id
    begin
      Tmdb.load_movie(movie_id)
    rescue
      puts "help help help #{movie_id}"
    end
    puts "Loaded #{movie_id}"
  end
end
