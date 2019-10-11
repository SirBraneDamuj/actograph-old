Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  get "/titles", :to => "titles#index"
  get "/watch", :to => "watch#watch"
  get "/tv_watch/:tmdb_id/:season_num/:episode_num", :to => "watch#tv"
  get "/movie_watch/:tmdb_id", :to => "watch#movie"

end
