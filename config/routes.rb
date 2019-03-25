Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :admin do
    get '/' => 'users#dashboard'

    resources :users do
      collection do
        get :dashboard
      end
    end

    resources :sessions do
      collection do
        get :login
        post :login_attempt
        get :logout
      end
    end

    resources :roles
    resources :permissions
    resources :parties
    resources :colors
    resources :types
    resources :plastic_scraps
    resources :fillers
    resources :bobins
    resources :gittis
    resources :tapes
    resources :thellies
    resources :daanas

  end
end
