class Chat < ApplicationRecord
  include Asynchronous
  attr_accessor :application_token

  belongs_to :application
  has_many :messages, dependent: :destroy

  validates :number, uniqueness: { scope: :application_id }

  scope :for_application_token, ->(application_token) { joins(:application).where(applications: { token: application_token }) }

  private

  def cache_key
    "application:#{application_token}:number"
  end

  def associations
    self.application = Application.find_by(token: application_token)
  end
end
