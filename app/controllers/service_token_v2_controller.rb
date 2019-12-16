class ServiceTokenV2Controller < ApplicationController
  def show
    token = Support::ServiceTokenAuthoritativeSource.get_public_key(service_slug: params[:service_slug])

    if token.present?
      render json: { token: token }, status: 200
    else
      head :not_found
    end
  end
end
