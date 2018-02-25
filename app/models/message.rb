class Message < ApplicationRecord
  has_many :statuses, foreign_key: 'message_id', class_name: 'MessageStatus'
  has_many :recipients, through: :statuses, source: :recipient
end
