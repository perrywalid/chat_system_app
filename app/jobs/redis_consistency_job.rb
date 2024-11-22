class RedisConsistencyJob < ApplicationJob
  queue_as :default
  sidekiq_options retry: 0, dead: false

  def perform
    RedisConsistency.new.execute
  end
end
