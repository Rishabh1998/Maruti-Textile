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

    resources :customer_accounts do
    end

    resources :orders
    resources :roles
    resources :permissions

    resources :divisions do
      collection do
        post :upload_division_image
      end
    end

    resources :sections do
      collection do
        post :upload_section_image
      end
    end

    resources :departments do
      collection do
        post :upload_department_image
      end
    end

    resources :items do
      collection do
        post :upload_item_image
      end
    end

    resources :offers do
      collection do
        post :upload_offer_image
      end
    end

  end
end
