
require 'rails_helper'

RSpec.describe 'Applications API', type: :request do
  let!(:applications) { create_list(:application, 5) }
  let!(:new_application) { create(:application) }

  describe 'GET /applications' do
    before { get '/applications' }

    it 'returns applications' do
      expect(json).not_to be_empty
      expect(json.size).to eq(Application.all.count)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /applications/:id' do
    context 'when the record exists' do
      let(:application) { applications.first }
      before { get "/applications/#{application.token}" }

      it 'returns the application' do
        expect(json).not_to be_empty
        expect(json['token']).to eq(application.token)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      before { get '/applications/invalid' }

      it 'returns a not found message' do
        expect(response.body).to match(/not found/)
      end

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end
    end
  end

  describe 'POST /applications' do
    context 'when the request is valid' do
      before { post '/applications', params: { data: attributes_for(:application) } }

      it 'creates a application' do
        expect(json['token']).to_not eq(nil)
        expect(json['chats_count']).to eq(0)
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before { post '/applications', params: { data: {} } }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end
    end
  end

  def json
    JSON.parse(response.body)
  end
end
