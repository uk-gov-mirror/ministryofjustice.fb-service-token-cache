class Support::ServiceTokenAuthoritativeSource
  def self.get_public_key(service_slug:)
    adapter = Adapters::KubectlAdapter.new(secret_name: service_slug,
                                           namespace: ENV['KUBECTL_SERVICES_NAMESPACE'])
    adapter.get_public_key
  end
end
