class ForceCreateActorTmdbIdConstraint < ActiveGraph::Migrations::Base
  def up
    add_constraint :Actor, :tmdb_id, force: true
  end

  def down
    drop_constraint :Actor, :tmdb_id
  end
end
