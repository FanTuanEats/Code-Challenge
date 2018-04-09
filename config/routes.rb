Rails.application.routes.draw do
    namespace :v1 do
        resources :assignments, only: [:index], defaults: { format: :json }
    end
end
