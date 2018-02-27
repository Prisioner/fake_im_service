Rails.application.routes.draw do
  apipie

  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      post 'authenticate', to: 'authentication#authenticate'
    end
  end
end
