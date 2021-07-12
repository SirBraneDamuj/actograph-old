class WatchController < ApplicationController
  def watch
    type = params[:type]
    id = params[:tmdb_id]
    if type == "tv"
      season_num = params[:season_num]
      episode_num = params[:episode_num]
      redirect_to "/tv_watch/#{id}/#{season_num}/#{episode_num}"
    elsif type == "movie"
      redirect_to "/movie_watch/#{id}"
    elsif type == "actor"
      redirect_to "/actors/#{id}?watched=true"
    end
  end

  def tv
    tv_id = params[:tmdb_id]
    season_num = params[:season_num]
    episode_num = params[:episode_num]
    @series = Tmdb.get_tv(tv_id)
    @episode = Tmdb.get_tv_episode(tv_id, season_num, episode_num)
    render_not_found if @series.nil?
    @tv_relationships = ActorService.tv_actor_relationships_for_episode(tv_id, season_num, episode_num)
    @movie_relationships = ActorService.movie_actor_relationships_for_episode(tv_id, season_num, episode_num)
  end

  def movie
    movie_id = params[:tmdb_id]
    @movie = Tmdb.get_movie(movie_id)
    render_not_found if @movie.nil?
    @tv_relationships = ActorService.tv_actor_relationships_for_movie(movie_id)
    @movie_relationships = ActorService.movie_actor_relationships_for_movie(movie_id)
  end
end
