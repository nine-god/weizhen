Rails.application.routes.draw do

  resources :messages #, except:[:edits,:update]
  resources :articles
  devise_for :users
  resources :users
  resources :products
  resources :home , only: [:index, :show,:update,:edit] do
    member do
      get 'contact_us'
    end
  end
  get 'ueditor_resources/handle_file'
  post 'ueditor_resources/handle_file'
  get 'ueditor_resources/show_image'
  root "home#index"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
