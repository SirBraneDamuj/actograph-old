class ForceCreateTvSeasonTmdbIdConstraint < ActiveGraph::Migrations::Base
  def up
    add_constraint :TvSeason, :tmdb_id, force: true
  end

  def down
    drop_constraint :TvSeason, :tmdb_id
  end
end
