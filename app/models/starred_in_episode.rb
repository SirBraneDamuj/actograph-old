class StarredInEpisode
  include Neo4j::ActiveRel

  from_class :Actor
  to_class :TvEpisode

  property :character_name
end
