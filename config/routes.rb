Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  resource :signup, only: %i[create]
  resources :authentications, only: %i[create]
  resources :users, only: %i[index show update]
end
