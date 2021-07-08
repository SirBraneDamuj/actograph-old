class StarredInMovie
  include ActiveGraph::Relationship

  from_class :Actor
  to_class :Movie

  property :character_name
end
