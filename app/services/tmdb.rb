module Tmdb
  API_KEY = ENV["TMDB_API_KEY"]

  def self.load_movie(movie_id, user_id = nil)
    movie = get_movie(movie_id)
    movie_node = create_or_get_movie_node(
      :tmdb_id => movie["id"],
      :name => movie["title"],
      :poster_path => movie["poster_path"]
    )
    movie_credits = get_movie_credits(movie_id)
    movie_credits["cast"].each do |actor|
      actor_node = create_or_get_actor_node(
        :tmdb_id => actor["id"],
        :name => actor["name"],
        :profile_path => actor["profile_path"]
      )
      StarredInMovie.create(
        :from_node => actor_node,
        :to_node => movie_node,
        :character_name => actor["character"]
      )
    end
    if user_id
      user = User.find(user_id)
      user.watched_movies << movie_node
      user.save!
    end
  end

  def self.load_season(tv_id, season_num, tv_show, season_resp)
    tv_show ||= get_tv(tv_id)
    series_node = create_or_get_tv_node(
      :tmdb_id => tv_show["id"],
      :name => tv_show["name"],
      :poster_path => tv_show["poster_path"]
    )
    season_resp ||= get_tv_season(tv_id, season_num)
    season_node = create_or_get_season_node(
      :tmdb_id => season_resp["id"],
      :season_number => season_num,
      :poster_path => season_resp["poster_path"]
    )
    series_node.seasons << season_node
    series_node.save
    season_resp["episodes"].each do |episode|
      episode_num = episode["episode_number"]
      episode_node = create_or_get_episode_node(
        :tmdb_id => episode["id"],
        :name => episode["name"],
        :episode_number => episode_num
      )
      season_node.episodes << episode_node

      sleep 1
      credits_resp = get_tv_episode_cast(tv_id, season_num, episode_num)
      all_cast = credits_resp["cast"] + credits_resp["guest_stars"]
      all_cast.each do |actor|
        actor_node = create_or_get_actor_node(
          :tmdb_id => actor["id"],
          :name => actor["name"],
          :profile_path => actor["profile_path"]
        )
        StarredInEpisode.create(
          :from_node => actor_node,
          :to_node => episode_node,
          :character_name => actor["character"]
        )
      end
    end
    season_node.save
  end

  def self.load_series(tv_id, user_id = nil)
    tv_show = get_tv(tv_id)
    series_node = create_or_get_tv_node(
      :tmdb_id => tv_show["id"],
      :name => tv_show["name"],
      :poster_path => tv_show["poster_path"]
    )
    tv_show["seasons"].each do |season|
      season_num = season["season_number"]
      next if season_num == 0
      season_node = create_or_get_season_node(
        :tmdb_id => season["id"],
        :season_number => season_num.to_i,
        :poster_path => season["poster_path"]
      )
      series_node.seasons << season_node

      sleep 1
      season_resp = get_tv_season(tv_id, season_num)
      season_resp["episodes"].each do |episode|
        episode_num = episode["episode_number"]
        episode_node = create_or_get_episode_node(
          :tmdb_id => episode["id"],
          :name => episode["name"],
          :episode_number => episode_num
        )
        season_node.episodes << episode_node

        sleep 1
        credits_resp = get_tv_episode_cast(tv_id, season_num, episode_num)
        all_cast = credits_resp["cast"] + credits_resp["guest_stars"]
        all_cast.each do |actor|
          actor_node = create_or_get_actor_node(
            :tmdb_id => actor["id"],
            :name => actor["name"],
            :profile_path => actor["profile_path"]
          )
          StarredInEpisode.create(
            :from_node => actor_node,
            :to_node => episode_node,
            :character_name => actor["character"]
          )
        end
      end
      season_node.save
    end
    series_node.save

    if user_id
      user = User.find(user_id)
      user.watched_episodes << series_node.seasons.episodes
      user.save!
    end
  end

  def self.create_or_get_movie_node(tmdb_id:, name:, poster_path:)
    Movie.find_by(:tmdb_id => tmdb_id) || Movie.create(
      :tmdb_id => tmdb_id,
      :name => name,
      :poster_path => poster_path
    )
  end

  def self.create_or_get_tv_node(tmdb_id:, name:, poster_path:)
    TvSeries.find_by(:tmdb_id => tmdb_id) || TvSeries.create(
      :tmdb_id => tmdb_id,
      :name => name,
      :poster_path => poster_path
    )
  end

  def self.create_or_get_season_node(tmdb_id:, season_number:, poster_path:)
    TvSeason.find_by(:tmdb_id => tmdb_id) || TvSeason.create(
      :tmdb_id => tmdb_id,
      :season_number => season_number,
      :poster_path => poster_path
    )
  end

  def self.create_or_get_episode_node(tmdb_id:, name:, episode_number:)
    TvEpisode.find_by(:tmdb_id => tmdb_id) || TvEpisode.create(
      :tmdb_id => tmdb_id,
      :name => name,
      :episode_number => episode_number
    )
  end

  def self.create_or_get_actor_node(tmdb_id:, name:, profile_path:)
    Actor.find_by(:tmdb_id => tmdb_id) || Actor.create(
      :tmdb_id => tmdb_id,
      :name => name,
      :profile_path => profile_path
    )
  end

  def self.get_movie(movie_id)
    request("https://api.themoviedb.org/3/movie/#{movie_id}")
  end

  def self.get_movie_credits(movie_id)
    request("https://api.themoviedb.org/3/movie/#{movie_id}/credits")
  end

  def self.get_tv(tv_id)
    request("https://api.themoviedb.org/3/tv/#{tv_id}")
  end

  def self.get_tv_season(tv_id, season_num)
    request("https://api.themoviedb.org/3/tv/#{tv_id}/season/#{season_num}")
  end

  def self.get_tv_episode(tv_id, season_num, episode_num)
    request("https://api.themoviedb.org/3/tv/#{tv_id}/season/#{season_num}/episode/#{episode_num}")
  end

  def self.get_tv_episode_cast(tv_id, season_num, episode_num)
    request("https://api.themoviedb.org/3/tv/#{tv_id}/season/#{season_num}/episode/#{episode_num}/credits")
  end

  def self.request(url)
    response = HTTP.get(
      url,
      :params => { :api_key => API_KEY }
    )
    if response.code != 200
      puts response.uri
      puts response.code
      puts response.to_s
      raise StandardError
    end
    response.parse
  end
end
