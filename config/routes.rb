Rails.application.routes.draw do
  apipie

  root 'apipie/apipies#index'

  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      post 'authenticate', to: 'authentication#authenticate'

      resources :messages, only: [:create]
      resources :message_statuses, only: [:show]
    end
  end
end
