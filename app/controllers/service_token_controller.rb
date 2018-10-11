class ServiceTokenController < ApplicationController
  def show
    @token = ServiceTokenService.get(params[:service_slug])
    if @token
      render json: {token: @token}, status: 200
    else
      render status: 404, content_type: 'application/json'
    end
  end
end
