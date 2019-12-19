Rails.application.routes.draw do
  root "post_images#index"
  get '/post/hashtag/:name', to: "post_images#hashtag"
  get 'notifications/:id' => 'notifications#index', as: 'notifications'
  put 'notifications/:id' => 'notifications#update', as: 'notification'


  resources :post_images do
    resources :post_comments, only: [:create, :destroy]
    resources :favorites, only: [:create, :destroy]
    get :reply, on: :member
  end

  resources :end_users do
    resources :relationships, only: [:create, :destroy]
    get :follows, on: :member
    get :followers, on: :member
    get :explore, on: :collection
  end

  resources :searches, only: [:index]
end