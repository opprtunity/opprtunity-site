ParasquidCs2066::Application.routes.draw do
  root :to => 'home#index'
  match '/auth/:provider/callback', to: 'sessions#create'
  match '/auth/failure', to: 'sessions#failure'
  match 'signout', to: 'sessions#destroy', as: 'signout'

  resources :matches
  resources :users

  namespace :api do
    api version: 1 do
      namespace 'industry' do
        get "offerings"
        get "needs"
      end
      resources :users do
        # change the route restrictions as needed
        resources :needs, only: [:get]
        resources :offerings, only: [:get]
        member do 
          get 'matches'
          scope '/meetings' do
            get 'upcoming'
            get 'past'
          end
        end
      end
    end
  end

end
