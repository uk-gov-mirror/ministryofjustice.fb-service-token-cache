Rails.application.routes.draw do
  get '/health', to: 'health#show'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/service/:service_slug', to: 'service_token#show'
end
