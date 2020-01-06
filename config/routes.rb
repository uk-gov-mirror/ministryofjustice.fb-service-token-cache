Rails.application.routes.draw do
  get '/health', to: 'health#show'
  get '/service/:service_slug', to: 'service_token#show'
  get '/service/v2/:service_slug', to: 'service_token_v2#show'
end
