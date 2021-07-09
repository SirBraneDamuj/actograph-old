module ApplicationHelper
  def actors_for_movie(movie)
    actors = []
    movie.cast_members.each_rel do |actor_appearance|
      actor = actor_appearance.from_node
      actors << { :name => actor.name, :character_names => [actor_appearance.character_name], :photo => actor.profile_path, :tmdb_id => actor.tmdb_id }
    end
    actors.sort { |a,b| a[:name] <=> b[:name] }
  end

  def actors_for_series(series)
    actors = {}
    series.seasons.episodes.cast_members.each_rel do |actor_appearance|
      actor = actor_appearance.from_node
      unless actors[actor.tmdb_id]
        actors[actor.tmdb_id] = {
          :photo => actor.profile_path,
          :name => actor.name,
          :character_names => Set.new,
          :tmdb_id => actor.tmdb_id
        }
      end
      actors[actor.tmdb_id][:character_names] << actor_appearance.character_name
    end
    actors.values.sort { |a,b| a[:name] <=> b[:name] }
  end

  def titles_for_actor(actor)
    movies = []
    actor.movie_appearances.each_rel do |movie_appearance|
      movie = movie_appearance.to_node
      movies << {
        :name => movie.name,
        :character_names => [movie_appearance.character_name],
        :photo => movie.poster_path,
        :tmdb_id => movie.tmdb_id
      }
    end
    series_appearances = {}
    actor.episode_appearances.each_rel do |ep_appearance|
      episode = ep_appearance.to_node
      series = episode.season.series
      unless series_appearances[series.tmdb_id]
        series_appearances[series.tmdb_id] = {
          :photo => series.poster_path,
          :name => series.name,
          :character_names => Set.new,
          :tmdb_id => series.tmdb_id
        }
      end
      series_appearances[series.tmdb_id][:character_names] << ep_appearance.character_name
    end
    {
      :movies => movies,
      :series => series_appearances.values
    }
  end
end
