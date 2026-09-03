Rails.application.routes.draw do
  resources :games
  resources :matches
  resources :points
  resources :games do
    member do
      post :p_point
      post :q_point
      get :start
      patch :set_start
      post :play
      delete :undo
    end
  end
  resources :matches do
    member do
      get :players
    end
  end
  root "matches#index"
end