class StarredInEpisode
  include ActiveGraph::Relationship

  from_class :Actor
  to_class :TvEpisode

  property :character_name
end
