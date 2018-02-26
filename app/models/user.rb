class User < ApplicationRecord
  devise :database_authenticatable, :validatable

  has_many :message_statuses
  has_many :messages, through: :message_statuses, source: :message
end
