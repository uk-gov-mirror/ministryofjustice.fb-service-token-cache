class PublicKeyService
  attr_reader :service_slug

  def initialize(service_slug:)
    @service_slug = service_slug
  end

  def call
    if cached_value
      cached_value
    else
      public_key = Support::ServiceTokenAuthoritativeSource.get_public_key(service_slug: service_slug)
      adapter.put(key, public_key, ex: ttl_in_seconds)
      public_key
    end
  end

  private

  def ttl_in_seconds
    60
  end

  def key
    @key ||= ["encoded-public-key", service_slug].join('-')
  end

  def cached_value
    @cached_value ||= adapter.get(key)
  end

  def adapter
    Adapters::RedisCacheAdapter
  end
end
