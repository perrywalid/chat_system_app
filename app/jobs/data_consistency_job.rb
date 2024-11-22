class DataConsistencyJob < ApplicationJob
  queue_as :default
  sidekiq_options retry: 0, dead: false

  def perform
    DataConsistency.new.execute
  end
end
