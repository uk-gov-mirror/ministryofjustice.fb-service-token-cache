class PublicKeyService
  attr_reader :service_slug, :namespace

  def initialize(service_slug:, namespace: ENV['KUBECTL_SERVICES_NAMESPACE'])
    @service_slug = service_slug
    @namespace = namespace
  end

  def call
    if ActiveModel::Type::Boolean.new.cast(ENV['IGNORE_CACHE'])
      public_key
    else
      if cached_value
        cached_value
      else
        adapter.put(key, public_key, ex: ttl_in_seconds)
        public_key
      end
    end
  end

  private

  def public_key
    @public_key ||=
      Support::ServiceTokenAuthoritativeSource.get_public_key(
        service_slug: service_slug,
        namespace: namespace
      )
  end

  def ttl_in_seconds
    ENV['SERVICE_TOKEN_CACHE_TTL'].to_i
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
