require 'rails_helper'

describe Support::ServiceTokenAuthoritativeSource do
  describe '.service_secret_name' do
    before do
      allow(described_class).to receive(:environment_slug).and_return('myenv')
    end

    it 'returns fb-service-(service_slug)-token-(environment_slug)' do
      expect(described_class.service_secret_name('my-service')).to eq('fb-service-my-service-token-myenv')
    end
  end

  describe '.platform_secret_name' do
    before do
      allow(described_class).to receive(:environment_slug).and_return('myenv')
    end

    it 'returns fb-platform-(service_slug)-token-(environment_slug)' do
      expect(described_class.platform_secret_name('my-service')).to eq('fb-platform-my-service-token-myenv')
    end
  end

  describe '.environment_slug' do
    before do
      allow(ENV).to receive(:[]).with('FB_ENVIRONMENT_SLUG').and_return('my-env')
    end

    it 'returns the environment variable FB_ENVIRONMENT_SLUG' do
      expect(described_class.environment_slug).to eq('my-env')
    end
  end

  describe '.get' do
    before do
      allow(ENV).to receive(:[]).with('FB_ENVIRONMENT_SLUG').and_return('my-env')
    end

    context 'when issuer is from platform namespace' do
      it 'gets the secret_name for the given slug' do
        expect(Adapters::KubectlAdapter).to receive(:get_platform_secret).with('fb-platform-platform-slug-token-my-env').and_return('foo')

        expect(described_class.get('platform-slug')).to eql('foo')
      end
    end

    context 'when issuer is from service namespace' do
      it 'gets the secret_name for the given slug' do
        expect(Adapters::KubectlAdapter).to receive(:get_platform_secret).with('fb-platform-service-slug-token-my-env').and_return(nil)
        expect(Adapters::KubectlAdapter).to receive(:get_service_secret).with('fb-service-service-slug-token-my-env').and_return('foo')

        expect(described_class.get('service-slug')).to eql('foo')
      end
    end
  end
end
