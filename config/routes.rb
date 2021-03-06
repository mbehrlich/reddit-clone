Rails.application.routes.draw do

  resources :users, only: [:show, :new, :create, :destroy]

  resources :sessions, only: [:new, :create, :destroy]

  resources :subs do
    resources :posts, only: [:new]
  end

  resources :posts, only: [:show, :create, :edit, :update, :destroy] do
    resources :comments, only: [:new]
    post 'upvote', to: 'votes#upvote'
    post 'downvote', to: 'votes#downvote'
  end

  resources :comments, only: [:create, :show] do
    post 'upvote', to: 'votes#upvote'
    post 'downvote', to: 'votes#downvote'
  end

  root to: "subs#index"

end
