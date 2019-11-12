Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  root "post_images#index"
  get '/post/hashtag/:name', to: "post_images#hashtag"
  get '/users/:profile_name' + '.json', to: "users#show" ,as: 'user_json'
  post '/users/:profile_name' + '.json', to: "users#update"
  get '/users/:profile_name/follows' + '.json', to: "users#follows", as: 'follows_user_json'
  get '/users/:profile_name/explore' + '.json', to: "users#explore", as: 'explore_users_json'

  resources :post_images do
    resources :post_comments, only: [:create, :destroy]
    resource :favorites, only: [:create, :destroy]
    get :reply, on: :member
  end

  # FIXME:usersモデルは削除予定
  # resources :users, param: :profile_name, only: [:edit, :index, :update, :show, :index] do
  #   resource :relationships, param: :profile_name, only: [:create, :destroy]
  #   get :follows, on: :member
  #   get :followers, on: :member
  #   get :explore, on: :collection
  # end

  resources :end_users do
    resource :relationships, param: :profile_name, only: [:create, :destroy]
    get :follows, on: :member
    get :followers, on: :member
    get :explore, on: :collection
  end

  resources :notifications, only: [:index]
end