Rails.application.routes.draw do
    namespace :admin do
        resources :assignments
        resources :restaurants
        resources :meals
        resources :delivery_zones
    end

    namespace :v1 do
        resources :assignments, only: [:index], defaults: { format: :json }
    end
end
