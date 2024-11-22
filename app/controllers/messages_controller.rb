class MessagesController < ApplicationController
  before_action :set_application_and_chat

  def create
    if @chat
      message = Message.new(permitted_params.merge(application_token: params[:application_token],
                                                   chat_number: params[:chat_number]))
      if message.async_create
        render json: message, status: :created
      else
        render json: message.errors, status: :unprocessable_entity
      end
    else
      render json: { error: 'Chat not found' }, status: :not_found
    end
  end

  def index
    if @chat
      messages = Message.for_chat(params[:application_token], params[:chat_number])
      render json: messages
    else
      render json: { error: 'Message not found' }, status: :not_found
    end
  end

  def search
    if @chat
      if params[:query].present?
        messages = Message.search(params[:query], scope_results: lambda { |message|
                                                                   message.for_chat(params[:application_token], params[:chat_number])
                                                                 })
        render json: messages, status: :ok
      else
        render json: { error: "Query parameter 'query' is missing." }, status: :bad_request
      end
    else
      render json: { error: 'Chat not found' }, status: :not_found
    end
  rescue Elasticsearch::Transport::Transport::Errors::ServiceUnavailable => e
    Rails.logger.error "Elasticsearch service unavailable: #{e.message}"
    render json: { error: 'Elasticsearch service unavailable' }, status: :service_unavailable
  end

  def show
    message = Message.find_by(chat: @chat,
                              number: params[:id])

    if message
      render json: message
    else
      render json: { error: 'Message not found' }, status: :not_found
    end
  end

  private

  def set_application_and_chat
    @application = Application.find_by(token: params[:application_token])
    @chat = @application&.chats&.find_by(number: params[:chat_number])
  end
end
