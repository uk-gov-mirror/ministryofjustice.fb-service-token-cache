require 'rails_helper'

describe Adapters::KubectlAdapter do
  let(:secret_name) { 'my-secret' }
  let(:namespace) { 'my-namespace' }

  before do
    allow(Adapters::ShellAdapter).to receive(:output_of).and_return('some output')
  end

  subject do
    described_class.new(secret_name: secret_name, namespace: namespace)
  end

  describe '#get_secret' do
    let(:kubectl_output) { 'kubectl output]' }
    let(:parsed_json) do
      {
        'data' => {
          'a_key' => 'a value',
          'another_key' => 'another value',
          'token' => 'token value'
        }
      }
    end

    before do
      allow(JSON).to receive(:parse).with(kubectl_output).and_return(parsed_json)
      allow(Base64).to receive(:decode64).with('token value').and_return('decoded token')
      allow(subject).to receive(:kubectl_cmd).and_return('kubectl cmd')
      allow(Adapters::ShellAdapter).to receive(:output_of).with('kubectl cmd').and_return(kubectl_output)
    end

    it 'calls kubectl_cmd passing the given secret name' do
      expect(subject).to receive(:kubectl_cmd)
      subject.get_secret
    end

    it 'gets the output of the kubectl_cmd' do
      expect(Adapters::ShellAdapter).to receive(:output_of).with('kubectl cmd').and_return(kubectl_output)
      subject.get_secret
    end

    it 'parses the kubectl output as JSON' do
      expect(JSON).to receive(:parse).with(kubectl_output).and_return(parsed_json)
      subject.get_secret
    end

    it 'base64-decodes the [data][token] key' do
      expect(Base64).to receive(:decode64).with('token value').and_return('decoded token')
      subject.get_secret
    end

    it 'returns the decoded token' do
      expect(subject.get_secret).to eq('decoded token')
    end

    context 'when shell adapter retruns empty string' do
      before :each do
        expect(Adapters::ShellAdapter).to receive(:output_of).with('kubectl cmd').and_return('')
      end

      it 'returns nil' do
        expect(subject.get_secret).to be_nil
      end
    end
  end
end
