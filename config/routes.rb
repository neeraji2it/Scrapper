Rails.application.routes.draw do
  devise_for :users
  root 'addresses#index'
  resources :addresses, only: [:index, :new, :create] do
    collection do
      delete :destroy_all
    end
  end
end
