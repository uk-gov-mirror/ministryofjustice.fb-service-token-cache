require 'rails_helper'

describe Adapters::ShellAdapter do
  let(:token) { SecureRandom.uuid }
  let(:message) do
    "failing cmd: /some/path/kubectl get configmaps -o jsonpath='{.data.PATRICK_STAR}' fb-spongebob-config-map --namespace=formbuilder-spongebob --token=#{token} --ignore-not-found=true"
  end

  describe '#redact_token' do
    context 'when a message needs redacting' do
      it 'should remove the token from the message' do
        expect(described_class.redact_token(message)).not_to include(token)
      end
    end
  end
end
