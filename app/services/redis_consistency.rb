class RedisConsistency
  def execute
    Application.find_each do |application|
      validate_application(application)

      application.chats.find_each do |chat|
        validate_chat(chat, application.token)
      end
    end
  end

  private

  def validate_application(application)
    persisted_number = application.chats.maximum(:number).to_i
    redis_number = Rails.cache.redis.get("application:#{application.token}:number")

    resync_application_number(application.token, persisted_number) if redis_number.to_i < persisted_number
  end

  def validate_chat(chat, application_token)
    persisted_chat_number = chat.messages.maximum(:number).to_i
    redis_chat_number = Rails.cache.redis.get("application:#{application_token}:chat:#{chat.number}:number")

    return unless redis_chat_number.to_i < persisted_chat_number

    resync_chat_number(chat.number, application_token,
                       persisted_chat_number)
  end

  def resync_application_number(application_token, persisted_number)
    Rails.cache.redis.set("application:#{application_token}:number", persisted_number)
  end

  def resync_chat_number(chat_number, application_token, persisted_number)
    Rails.cache.redis.set("application:#{application_token}:chat:#{chat_number}:number", persisted_number)
  end
end
