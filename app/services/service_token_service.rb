class ServiceTokenService
  def self.get(service_slug)
    if token = cache.get(service_slug)
      token
    else
      get_from_source(service_slug)
    end
  end

  def self.cache
    Support::ServiceTokenCache
  end

  def self.get_from_source(service_slug)
    begin
      token = Support::ServiceTokenAuthoritativeSource.get(service_slug)
      cache.put(service_slug, token)
      token
    rescue CmdFailedError => e
      Rails.logger.warn "Failed getting service_slug #{service_slug}\nException details: #{e}"
      nil
    end
  end
end
