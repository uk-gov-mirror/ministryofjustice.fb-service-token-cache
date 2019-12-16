class ServiceTokenV2Controller < ApplicationController
  def show
    token = Support::ServiceTokenAuthoritativeSource.get_public_key(service_slug: params[:service_slug])

    render json: {token: token}, status: 200
  end
end
