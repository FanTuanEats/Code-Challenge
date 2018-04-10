Rails.application.routes.draw do
    namespace :admin do
        resources :assignments
        resources :delivery_zones
        resources :restaurants do
            resources :meals
            resources :restrict_restaurant_days
            resources :restrict_restaurant_delivery_zones
        end
    end

    namespace :v1 do
        resources :assignments, only: [:index], defaults: { format: :json }
    end
end
