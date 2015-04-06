Rails.application.routes.draw do
  root 'addresses#index'
  resources :addresses, only: [:index, :new, :create, :destroy]
end
