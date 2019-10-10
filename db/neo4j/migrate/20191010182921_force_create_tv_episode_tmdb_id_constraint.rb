class ForceCreateTvEpisodeTmdbIdConstraint < Neo4j::Migrations::Base
  def up
    add_constraint :TvEpisode, :tmdb_id, force: true
  end

  def down
    drop_constraint :TvEpisode, :tmdb_id
  end
end
