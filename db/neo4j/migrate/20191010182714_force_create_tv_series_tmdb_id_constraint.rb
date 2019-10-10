class ForceCreateTvSeriesTmdbIdConstraint < Neo4j::Migrations::Base
  def up
    add_constraint :TvSeries, :tmdb_id, force: true
  end

  def down
    drop_constraint :TvSeries, :tmdb_id
  end
end
