class Adapters::KubectlAdapter
  attr_reader :secret_name, :namespace

  def initialize(secret_name:, namespace:)
    @secret_name = secret_name
    @namespace = namespace

    validate_params!
  end

  def get_public_key
    command = [
      kubectl_binary,
      'get',
      'configmaps',
      '-o',
      "jsonpath='{.data.ENCODED_PUBLIC_KEY}'",
      "fb-#{secret_name}-config-map",
    ] + [kubectl_args]

    Adapters::ShellAdapter.output_of(command)
  rescue CmdFailedError => e
    Raven.capture_exception(e)
    ''
  end

  private

  def validate_params!
    if !secret_name.match(/\A[a-zA-Z0-9\-_]*\z/)
      raise ArgumentError.new('rejected potentially dangerous secret_name')
    end

    if !namespace.match(/\A[a-zA-Z0-9\-_]*\z/)
      raise ArgumentError.new('rejected potentially dangerous namespace')
    end
  end

  def kubectl_args(context: ENV['KUBECTL_CONTEXT'],
                   bearer_token: ENV['KUBECTL_BEARER_TOKEN'])
    args = []
    args << '--context=' + context unless context.blank?
    args << '--namespace=' + namespace unless namespace.blank?
    args << '--token=' + bearer_token  unless bearer_token.blank?
    args << '--ignore-not-found=true'

    args.compact.join(' ')
  end

  def kubectl_binary
    Adapters::ShellAdapter.output_of('which kubectl')
  end
end
