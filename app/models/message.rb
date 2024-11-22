class Message < ApplicationRecord
  include Asynchronous
  attr_accessor :chat_number, :application_token

  searchkick word_middle: [:body],
             searchable: [:body]

  belongs_to :chat

  validates :number, uniqueness: { scope: :chat_id }

  scope :for_chat, ->(application_token, chat_number) {
    joins(:chat).where(chats: { application_id: Application.find_by(token: application_token).id, number: chat_number })
  }

  def cache_key
    "application:#{application_token}:chat:#{chat_number}:number"
  end

  def associations
    self.chat = Chat.for_application_token(application_token).find_by(number: chat_number)
  end
end
