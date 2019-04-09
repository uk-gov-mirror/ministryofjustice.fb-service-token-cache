class Adapters::KubectlAdapter
  attr_reader :secret_name, :namespace

  def self.get_service_secret(name)
    namespace = ENV['KUBECTL_SERVICES_NAMESPACE']
    instance = new(secret_name: name, namespace: namespace)
    instance.get_secret
  end

  def self.get_platform_secret(name)
    namespace = ENV['KUBECTL_PLATFORM_NAMESPACE']
    instance = new(secret_name: name, namespace: namespace)
    instance.get_secret
  end

  def initialize(secret_name:, namespace:)
    @secret_name = secret_name
    @namespace = namespace
  end

  def get_secret
    Base64.decode64(JSON.parse(json)['data']['token'])
  end

  private

  def json
    Adapters::ShellAdapter.output_of(kubectl_cmd)
  end

  def kubectl_cmd
    [
      kubectl_binary,
      'get',
      'secret',
      secret_name,
      '-o',
      'json'
    ] + [kubectl_args]
  end

  def kubectl_args(context: ENV['KUBECTL_CONTEXT'],
                   bearer_token: ENV['KUBECTL_BEARER_TOKEN'])
    args = []
    args << '--context=' + context unless context.blank?
    args << '--namespace=' + namespace unless namespace.blank?
    args << '--token=' + bearer_token  unless bearer_token.blank?

    args.compact.join(' ')
  end

  def kubectl_binary
    Adapters::ShellAdapter.output_of('which kubectl')
  end
end
