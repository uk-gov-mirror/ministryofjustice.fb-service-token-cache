Rails.application.routes.draw do
  get '/health', to: 'health#show'
  get '/service/v2/:service_slug', to: 'service_token_v2#show'
  get '/v3/applications/:application/namespaces/:namespace', to: 'service_token_v3#show'
end
