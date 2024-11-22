module Asynchronous
  extend ActiveSupport::Concern

  included do
    def async_create
      assign_number
      associations
      PersistObjectJob.perform_later(object: attributes, type: self.class.name)
    end

    private

    def assign_number
      self.number ||= fetch_next_number
    end

    def fetch_next_number
      Rails.cache.redis.incr(cache_key)
    end
  end
end
