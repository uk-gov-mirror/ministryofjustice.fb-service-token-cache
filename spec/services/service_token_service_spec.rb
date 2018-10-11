require 'rails_helper'

describe ServiceTokenService do
  describe '.get' do
    it 'tries to get a cached value' do
      expect(described_class.cache).to receive(:get).with('my-service').and_return('the-token')
      described_class.get('my-service')
    end

    context 'when there is a cached value' do
      before do
        allow(described_class.cache).to receive(:get).with('my-service').and_return('the-token')
      end

      it 'returns the value' do
        expect(described_class.get('my-service')).to eq('the-token')
      end
    end

    context 'when there is no cached value' do
      before do
        allow(described_class.cache).to receive(:get).with('my-service').and_return(nil)
      end

      it 'tries to get one from the authoritative source' do
        expect(Support::ServiceTokenAuthoritativeSource).to receive(:get).with('my-service').and_return('the-token')
        described_class.get('my-service')
      end

      context 'when it gets a value' do
        before do
          allow(Support::ServiceTokenAuthoritativeSource).to receive(:get).with('my-service').and_return('the-token')
        end

        it 'puts it to the cache for the given service slug' do
          expect(described_class.cache).to receive(:put).with('my-service', 'the-token')
          described_class.get('my-service')
        end

        it 'returns the value' do
          expect(described_class.get('my-service')).to eq('the-token')
        end
      end

      context 'when the authoritative source raises an error' do
        before do
          allow(Support::ServiceTokenAuthoritativeSource).to receive(:get).with('my-service').and_raise(CmdFailedError)
        end

        it 'returns nil' do
          expect(described_class.get('my-service')).to be_nil
        end
      end
    end
  end
end
