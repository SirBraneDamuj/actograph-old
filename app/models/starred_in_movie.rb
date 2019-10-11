class StarredInMovie
  include Neo4j::ActiveRel

  from_class :Actor
  to_class :Movie

  property :character_name
end
