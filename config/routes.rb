Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  root "post_images#index"
  get '/post/hashtag/:name', to: "post_images#hashtag"

  resources :post_images do
    resources :post_comments, only: [:create, :destroy]
    resource :favorites, only: [:create, :destroy]
    get :reply, on: :member
  end

  resources :users, param: :profile_name, only: [:edit, :index, :update, :show, :index] do
    resource :relationships, param: :profile_name, only: [:create, :destroy]
    get :follows, on: :member
    get :followers, on: :member
    get :explore, on: :collection
  end

  resources :notifications, only: [:index]

end