Rails.application.routes.draw do
  get 'youtube/new', to: 'youtube#new', as: :new_youtube
  get 'youtube/show', to: 'youtube#show', as: :show_youtube
  resources :boards
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
