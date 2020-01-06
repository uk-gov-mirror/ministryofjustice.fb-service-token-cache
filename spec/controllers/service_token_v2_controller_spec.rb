require 'rails_helper'

RSpec.describe ServiceTokenV2Controller do
  describe '#show' do
    it 'returns public key' do
      allow(Support::ServiceTokenAuthoritativeSource).to receive(:get_public_key).and_return('v2-public-key')

      get :show, params: { service_slug: 'test-service' }
      expect(response).to be_successful
      expect(JSON.parse(response.body)['token']).to eql('v2-public-key')
    end

    context 'when service does not exist' do
      it 'returns 404' do
        allow(Support::ServiceTokenAuthoritativeSource).to receive(:get_public_key).and_return('')

        get :show, params: { service_slug: 'test-service' }
        expect(response).to be_not_found
      end
    end
  end
end
