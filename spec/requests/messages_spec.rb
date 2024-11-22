require 'rails_helper'

RSpec.describe 'Messages API', type: :request do
  # Initialize test data
  let!(:application) { create(:application) }
  let!(:chat) { create(:chat, application: application) }
  let!(:messages) { create_list(:message, 5, chat: chat) }

  # Define valid and invalid attributes based on your Message model
  # Adjust the attributes as per your Message model's validations and fields
  let(:valid_attributes) { { body: 'This is a test message', number: 101 } }
  let(:invalid_attributes) { { body: nil, number: nil } }

  # Helper method to parse JSON responses
  def json
    JSON.parse(response.body)
  end

  # Test suite for GET /applications/:application_token/chats/:chat_number/messages
  describe 'GET /applications/:application_token/chats/:chat_number/messages' do
    context 'when the chat exists' do
      before { get "/applications/#{application.token}/chats/#{chat.number}/messages" }

      it 'returns messages' do
        expect(json).not_to be_empty
        expect(json.size).to eq(5)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the chat does not exist' do
      before { get "/applications/#{application.token}/chats/999/messages" }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end
    end

    context 'when the application does not exist' do
      before { get "/applications/invalidtoken/chats/#{chat.number}/messages" }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end
    end
  end

  describe 'GET /applications/:application_token/chats/:chat_number/messages/:number' do
    context 'when the message exists' do
      let(:message) { messages.first }
      before { get "/applications/#{application.token}/chats/#{chat.number}/messages/#{message.number}" }

      it 'returns the message' do
        expect(json).not_to be_empty
        expect(json['number']).to eq(message.number)
        expect(json['body']).to eq(message.body)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the message does not exist' do
      before { get "/applications/#{application.token}/chats/#{chat.number}/messages/999" }

      it 'returns a not found message' do
        expect(response.body).to match(/Message not found/)
      end

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end
    end

    context 'when the chat does not exist' do
      before { get "/applications/#{application.token}/chats/0/messages/#{messages.first.number}" }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end
    end

    context 'when the application does not exist' do
      before { get "/applications/invalidtoken/chats/#{chat.number}/messages/#{messages.first.number}" }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end
    end
  end

  describe 'POST /applications/:application_token/chats/:chat_number/messages' do
    context 'when the request is valid' do
      before { post "/applications/#{application.token}/chats/#{chat.number}/messages", params: { data: attributes_for(:message).merge(valid_attributes) } }

      it 'creates a message' do
        expect(json['number']).to eq(101)
        expect(json['body']).to eq('This is a test message')
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the chat does not exist' do
      before { post "/applications/#{application.token}/chats/999/messages", params: { data: attributes_for(:message).merge(valid_attributes) } }

      it 'returns a not found message' do
        expect(response.body).to match(/Chat not found/)
      end

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end
    end

    context 'when the application does not exist' do
      before { post "/applications/invalidtoken/chats/#{chat.number}/messages", params: { data: attributes_for(:message).merge(valid_attributes) } }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end
    end
  end
end