class Chat < ApplicationRecord
  belongs_to :application
  has_many :messages, dependent: :destroy

  validates :number, uniqueness: { scope: :application_id }

  def initialize(attributes = {})
    super
    self.number = next_number
  end

  # before_create :increment_counter

  # def increment_counter
  #   cache_key = "application:#{application.token}:chat_counter"
  #   number = Rails.cache.increment(cache_key, 1, initial: 0)
  # end
  private

  def next_number
    cache_key = "application:#{application.token}:chat_counter"
    Rails.cache.increment(cache_key, 1, initial: 0)
  end
end
