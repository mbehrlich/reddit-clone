Rails.application.routes.draw do

  resources :users, only: [:show, :new, :create, :destroy]

  resources :sessions, only: [:new, :create, :destroy]

  resources :subs

  root to: "subs#index"

end
