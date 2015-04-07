Rails.application.routes.draw do
  root 'addresses#index'
  resources :addresses, only: [:index, :new, :create, :destroy] do
    collection do
      delete :destroy_all
    end
  end
end
