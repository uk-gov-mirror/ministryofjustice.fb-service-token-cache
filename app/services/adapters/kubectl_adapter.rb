class Adapters::KubectlAdapter
  attr_reader :secret_name, :namespace

  def self.get_secret(name)
    instance = new(secret_name: name)
    instance.get_secret
  end

  def initialize(secret_name:)
    @secret_name = secret_name
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
                   bearer_token: ENV['KUBECTL_BEARER_TOKEN'],
                   namespace: ENV['KUBECTL_SERVICES_NAMESPACE'])
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
