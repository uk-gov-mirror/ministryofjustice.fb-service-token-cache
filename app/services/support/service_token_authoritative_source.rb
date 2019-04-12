class Support::ServiceTokenAuthoritativeSource
  def self.get(service_slug)
    Adapters::KubectlAdapter.get_platform_secret(platform_secret_name(service_slug)) || Adapters::KubectlAdapter.get_service_secret(service_secret_name(service_slug))
  end

  def self.get_service_secret(slug)
    Adapters::KubectlAdapter.get_secret(service_secret_name(service_slug))
  end

  def self.get_platform_secret(slug)
    Adapters::KubectlAdapter.get_secret(platform_secret_name(service_slug))
  end

  def self.service_secret_name(service_slug)
    ['fb-service', service_slug, 'token', environment_slug].join('-')
  end

  def self.platform_secret_name(service_slug)
    ['fb-platform', service_slug, 'token', environment_slug].join('-')
  end

  private

  def self.environment_slug
    ENV['FB_ENVIRONMENT_SLUG']
  end
end
