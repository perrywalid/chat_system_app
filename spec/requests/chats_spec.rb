require 'rails_helper'

RSpec.describe 'Chats API', type: :request do
  let!(:application) { create(:application) }
  let!(:chats) { create_list(:chat, 5, application: application) }
  
  describe 'GET /applications/:application_token/chats' do
    context 'when the application exists' do
      before { get "/applications/#{application.token}/chats" }

      it 'returns chats' do
        expect(json).not_to be_empty
        expect(json.size).to eq(5)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the application does not exist' do
      before { get '/applications/invalidtoken/chats' }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end
    end
  end

  describe 'GET /applications/:application_token/chats/:chat_number' do
    context 'when the chat exists' do
      let(:chat) { chats.first }
      before { get "/applications/#{application.token}/chats/#{chat.number}" }

      it 'returns the chat' do
        expect(json).not_to be_empty
        expect(json['number']).to eq(chat.number)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the chat does not exist' do
      before { get "/applications/#{application.token}/chats/invalidtoken" }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end
    end

    context 'when the application does not exist' do
      before { get "/applications/invalidtoken/chats/#{chats.first.number}" }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end
    end
  end

  describe 'POST /applications/:application_token/chats' do
    context 'when the request is valid' do
      before { post "/applications/#{application.token}/chats", params: { data: attributes_for(:chat) } }

      it 'creates a chat' do
        expect(json['number']).to be > 0
        expect(json['messages_count']).to eq(0)
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the application does not exist' do
      before { post '/applications/invalidtoken/chats', params: { data: attributes_for(:chat) } }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end
    end
  end

  def json
    JSON.parse(response.body)
  end
end