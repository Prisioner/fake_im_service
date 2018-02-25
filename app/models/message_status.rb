class MessageStatus < ApplicationRecord
  belongs_to :message
  belongs_to :recipient
  belongs_to :user
end
