Rails.application.routes.draw do
  devise_for :users

  root "home#welcome"
  resources :genres, only: :index do
    member do
      get "movies"
    end
  end
  resources :movies, only: [:index, :show] do
    member do
      get :send_info
      post :add_comment
    end
    collection do
      get :export
    end
  end
  resources :comments, only: :destroy
  namespace :api do
    resources :movies, only: [:index, :show]
  end

  get :top_commenters, controller: :comments, action: :top_commenters
end
