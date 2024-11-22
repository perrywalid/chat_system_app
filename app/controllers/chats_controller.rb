class ChatsController < ApplicationController
  before_action :set_application

  def create
    if @application
      chat = Chat.new(permitted_params.merge(application_token: @application.token))
      if chat.async_create
        render json: chat, status: :created
      else
        render json: chat.errors, status: :unprocessable_entity
      end
    else
      unless @application
        render json: { error: "Application with token #{params[:application_token]} not found" },
               status: :not_found
      end
    end
  end

  def index
    if @application
      render json: @application.chats
    else
      render json: { error: "Application with token #{params[:application_token]} not found" }, status: :not_found
    end
  end

  def show
    if @application
      chat = @application&.chats&.find_by(number: params[:number])
      if chat
        render json: chat
      else
        render json: { error: "Chat with number #{params[:number]} not found" }, status: :not_found
      end
    else
      render json: { error: "Application with token #{params[:application_token]} not found" }, status: :not_found
    end
  end

  def set_application
    @application = Application.find_by(token: params[:application_token])
  end
end
