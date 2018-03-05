Rails.application.routes.draw do
  apipie

  root 'apipie/apipies#index'

  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      post 'authenticate', to: 'authentication#authenticate'

      resource :messages, only: [:create]
    end
  end
end
