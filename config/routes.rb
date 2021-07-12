Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root to: "home#index"
  get "/home", :to => "home#index"

  get "/titles", :to => "titles#index"
  get "/titles/new", :to => "titles#new"
  post "/titles/create", :to => "titles#create"

  get "/watch", :to => "watch#watch"
  get "/tv_watch/:tmdb_id/:season_num/:episode_num", :to => "watch#tv"
  get "/movie_watch/:tmdb_id", :to => "watch#movie"

  get "/movies", :to => "movies#index"
  get "/movies/:tmdb_id", :to => "movies#show"
  get "/movies/:tmdb_id/watch", :to => "movies#watch"
  get "/movies/:tmdb_id/unwatch", :to => "movies#unwatch"

  get "/series", :to => "series#index"

  get "/series/:tmdb_id", :to => "series#show"
  get "/series/:tmdb_id/watch", :to => "series#watch"
  get "/series/:tmdb_id/unwatch", :to => "series#unwatch"

  get "/series/:tmdb_id/seasons/:season_number", :to => "series#show_season"
  get "/series/:tmdb_id/seasons/:season_number/watch", :to => "series#watch_season"
  get "/series/:tmdb_id/seasons/:season_number/unwatch", :to => "series#unwatch_season"

  get "/series/:tmdb_id/seasons/:season_number/episodes/:episode_number", :to => "series#show_episode"
  get "/series/:tmdb_id/seasons/:season_number/episodes/:episode_number/watch", :to => "series#watch_episode"
  get "/series/:tmdb_id/seasons/:season_number/episodes/:episode_number/unwatch", :to => "series#unwatch_episode"

  get "/actors", :to => "actors#index"
  get "/actors/:tmdb_id", :to => "actors#show"

  get "/users/new", :to => "users#new"
  post "/users", :to => "users#create"

  get "/login", :to => "users#login"
  post "/login", :to => "users#do_login"
  get "/logout", :to => "users#logout"

end
