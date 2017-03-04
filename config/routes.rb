Rails.application.routes.draw do
  get 'comments/index'

  resources :products, only: :index do
    resources :comments, only: :index
  end

  root 'products#index'

end
