class ForceCreateMovieTmdbIdConstraint < Neo4j::Migrations::Base
  def up
    add_constraint :Movie, :tmdb_id, force: true
  end

  def down
    drop_constraint :Movie, :tmdb_id
  end
end
