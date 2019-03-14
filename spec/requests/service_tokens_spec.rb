require 'rails_helper'

describe 'ServiceToken API', type: :request do
  let(:headers) {
    {
      'content-type' => 'application/json'
    }
  }
  let(:service_slug) { 'my-service' }

  describe 'a GET request' do
    context 'to /service/:service_slug' do
      let(:url) { "/service/#{service_slug}" }

      context 'when the service slug has a corresponding token' do
        before do
          allow(ServiceTokenService).to receive(:get).with(service_slug).and_return('mytoken')
        end

        it_behaves_like 'a JSON-only API', :get, '/service/my-service'

        describe 'the response' do
          before do
            get url, headers: headers
          end
          it 'has status 200' do
            expect(response).to have_http_status(200)
          end
          it 'has a valid JSON body' do
            expect{JSON.parse(response.body)}.to_not raise_error
          end
          it 'has the token in the body' do
            expect(response.body).to eq({token: 'mytoken'}.to_json)
          end
        end
      end
    end
  end
end
