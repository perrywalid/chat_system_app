class PersistObjectJob < ApplicationJob
  queue_as :default
  sidekiq_options retry: 0, dead: false

  def perform(object:, type:)
    type.constantize.create!(object)
  end
end
