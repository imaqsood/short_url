Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  # This is here so you can see your resque jobs if you're trying to debug
  # Just go to localhost:3000/admin/jobs to see
  require 'resque/server'
  mount Resque::Server, at: '/admin/jobs'

  resources :short_urls, only: [:index, :create, :show], format: :json
end
