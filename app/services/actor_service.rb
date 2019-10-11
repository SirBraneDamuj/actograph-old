class ActorService
  def self.tv_actor_relationships_for_episode(tv_id, season_num, episode_num)
    cast = Tmdb.get_tv_episode_cast(tv_id, season_num, episode_num)
    full_cast = cast["cast"] + cast["guest_stars"]
    result = Hash.new { |hash, key| hash[key] = [] }
    full_cast
      .each do |actor|
        character_name = actor["character"]
        actor_node = Actor.where(:tmdb_id => actor["id"])
        next if actor_node.nil?
        actor_node
          .episode_appearances(:episode, :character)
          .season(:season)
          .series(:series).where_not(:tmdb_id => tv_id.to_i)
          .pluck(:node2, :episode, :character, :season, :series)
          .uniq
          .select(&:present?)
          .each do |(actor, episode, character, season, series)|
            result[actor.tmdb_id].push({
              :this_character => character_name,
              :actor => actor,
              :episode => episode,
              :character => character,
              :season => season,
              :series => series
            })
          end
      end
    result
  end

  def self.movie_actor_relationships_for_episode(tv_id, season_num, episode_num)
    cast = Tmdb.get_tv_episode_cast(tv_id, season_num, episode_num)
    full_cast = cast["cast"] + cast["guest_stars"]
    result = Hash.new { |hash, key| hash[key] = [] }
    full_cast.each do |actor|
      character_name = actor["character"]
      actor_node = Actor.where(:tmdb_id => actor["id"])
      next if actor_node.nil?
      actor_node
        .movie_appearances(:movie, :character)
        .pluck(:node2, :movie, :character)
        .uniq
        .select(&:present?)
        .each do |(actor, movie, character)|
          result[actor.tmdb_id].push({
            :this_character => character_name,
            :actor => actor,
            :movie => movie,
            :character => character
          })
        end
    end
    result
  end

  def self.tv_actor_relationships_for_movie(movie_id)
    cast = Tmdb.get_movie_credits(movie_id)["cast"]
    result = Hash.new { |hash, key| hash[key] = [] }
    cast
      .each do |actor|
        character_name = actor["character"]
        actor_node = Actor.where(:tmdb_id => actor["id"])
        next if actor_node.nil?
        actor_node
          .episode_appearances(:episode, :character)
          .season(:season)
          .series(:series)
          .pluck(:node2, :episode, :character, :season, :series)
          .uniq
          .select(&:present?)
          .each do |(actor, episode, character, season, series)|
            result[actor.tmdb_id].push({
              :this_character => character_name,
              :actor => actor,
              :episode => episode,
              :character => character,
              :season => season,
              :series => series
            })
          end
      end
    result
  end

  def self.movie_actor_relationships_for_movie(movie_id)
    cast = Tmdb.get_movie_credits(movie_id)["cast"]
    result = Hash.new { |hash, key| hash[key] = [] }
    cast.each do |actor|
      character_name = actor["character"]
      actor_node = Actor.where(:tmdb_id => actor["id"])
      next if actor_node.nil?
      actor_node
        .movie_appearances(:movie, :character).where_not(:tmdb_id => movie_id.to_i)
        .pluck(:node2, :movie, :character)
        .uniq
        .select(&:present?)
        .each do |(actor, movie, character)|
          result[actor.tmdb_id].push({
            :this_character => character_name,
            :actor => actor,
            :movie => movie,
            :character => character
          })
        end
    end
    result
  end
end
