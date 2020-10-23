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

  describe '#get_public_key' do
    context 'when code injection' do
      context 'with dangerous secret_name' do
        let(:secret_name) { '; curl https://example.com;' }
        let(:namespace) { 'some-namespace' }

        subject do
          described_class.new(secret_name: secret_name, namespace: namespace)
        end

        it 'raises an error' do
          expect do
            subject.get_public_key
          end.to raise_error(ArgumentError)
        end
      end

      context 'with dangerous namespace' do
        let(:secret_name) { 'some-namespace' }
        let(:namespace) { '; curl https://example.com;' }

        subject do
          described_class.new(secret_name: secret_name, namespace: namespace)
        end

        it 'raises an error' do
          expect do
            subject.get_public_key
          end.to raise_error(ArgumentError)
        end
      end
    end

    context 'when a CmdFailedError is raised' do
      subject do
        described_class.new(secret_name: 'some-secret', namespace: 'some-namespace')
      end

      it 'should rescue and return empty string' do
        allow(Adapters::ShellAdapter).to receive(:output_of).and_raise(CmdFailedError)

        expect(subject.get_public_key).to eq('')
      end
    end
  end
end
