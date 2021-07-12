class SeriesController < ApplicationController
  before_action :require_login

  before_action :_find_series, :except => [:index]
  before_action :_find_season, :only => [:show_season, :show_episode, :watch_season, :watch_episode, :unwatch_season, :unwatch_episode]
  before_action :_find_episode, :only => [:show_episode, :watch_episode, :unwatch_episode]

  def index
    @offset = params[:offset]&.to_i || 0
    @watched = params[:watched] == "true"
    if @watched
      @series = @user.watched_episodes.season.series.uniq.slice(@offset, 25)
    else
      @series = TvSeries.order(:name).limit(25).offset(@offset)
    end
  end

  def watch
    @user.watched_episodes << @series.seasons.episodes
    unless @user.save
      flash[:alert] = "Failed to watch all episodes"
    else
      flash[:notice] = "#{@series.name} is now Watched."
    end
    redirect_to "/series/#{@tmdb_id}"
  end

  def unwatch
    @series.seasons.episodes.watchers.delete(@user)
    flash[:notice] = "#{@series.name} is now Not Watched."
    redirect_to "/series/#{@tmdb_id}"
  end

  def watch_season
    @user.watched_episodes << @season.episodes
    unless @user.save
      flash[:alert] = "Failed to watch all episodes"
    else
      flash[:notice] = "#{@series.name}, #{@season_number} is now Watched."
    end
    redirect_to "/series/#{@tmdb_id}/seasons/#{@season_number}"
  end

  def unwatch_season
    @season.episodes.watchers.delete(@user)
    flash[:notice] = "#{@series.name}, Season #{@season_number} is now Not Watched."
    redirect_to "/series/#{@tmdb_id}/seasons/#{@season_number}"
  end

  def watch_episode
    @user.watched_episodes << @episode
    unless @user.save
      flash[:alert] = "Failed to watch episode"
    else
      flash[:notice] = "#{@series.name} #{@season_number}x#{@episode_number} is now Watched."
    end
    redirect_to "/series/#{@tmdb_id}/seasons/#{@season_number}/episodes/#{@episode_number}"
  end

  def unwatch_episode
    @user.watched_episodes.delete(@episode)
    unless @user.save
      flash[:alert] = "Failed to unwatch episode"
    else
      flash[:notice] = "#{@series.name} #{@season_number}x#{@episode_number} is now Not Watched."
    end
    redirect_to "/series/#{@tmdb_id}/seasons/#{@season_number}/episodes/#{@episode_number}"
  end

  def show; end

  def show_season; end

  def show_episode; end

  private

  def _find_series
    @tmdb_id = params[:tmdb_id].to_i
    @series = TvSeries.find_by(:tmdb_id => @tmdb_id)
    unless @series
      flash[:alert] = "Series #{@tmdb_id} not found"
      redirect_to "/series"
    end
  end

  def _find_season
    @season_number = params[:season_number].to_i
    @season = @series.seasons.where(:season_number => @season_number).first
    unless @season
      flash[:alert] = "Season #{@season_number} of #{@series.name} not found"
      redirect_to "/series/#{@tmdb_id}"
    end
  end

  def _find_episode
    @episode_number = params[:episode_number].to_i
    @episode = @season.episodes.where(:episode_number => @episode_number).first
    unless @episode
      flash[:alert] = "Episode #{@episode_number} of Season #{@season_number} of #{@series.name} not found"
      redirect_to "/series/#{@tmdb_id}/seasons/#{@season_number}"
    end
  end
end
