class Support::ServiceTokenAuthoritativeSource
  def self.get_public_key(service_slug:, namespace:)
    adapter = Adapters::KubectlAdapter.new(secret_name: service_slug,
                                           namespace: namespace)
    adapter.get_public_key
  end
end
