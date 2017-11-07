Rails.application.routes.draw do
  resources :news
  resources :products
  get 'home/show'
  get 'home/about' 
  root "home#show"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
