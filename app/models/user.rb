class User < ApplicationRecord
  has_many :message_statuses
  has_many :messages, through: :message_statuses, source: :message
end
