class DataConsistency
  def execute
    Application.find_each do |app|
      app.update(chats_count: app.chats.count)
    end
    Chat.find_each do |chat|
      chat.update(messages_count: chat.messages.count)
    end
  end
end
