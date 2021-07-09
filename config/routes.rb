Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  get "/titles", :to => "titles#index"
  get "/titles/new", :to => "titles#new"
  post "/titles/create", :to => "titles#create"
  get "/watch", :to => "watch#watch"
  get "/tv_watch/:tmdb_id/:season_num/:episode_num", :to => "watch#tv"
  get "/movie_watch/:tmdb_id", :to => "watch#movie"
  get "/home", :to => "home#index"
  get "/movies", :to => "movies#index"
  get "/movies/:tmdb_id", :to => "movies#show"
  get "/series", :to => "series#index"
  get "/series/:tmdb_id", :to => "series#show"
  get "/actors", :to => "actors#index"
  get "/actors/:tmdb_id", :to => "actors#show"

end
