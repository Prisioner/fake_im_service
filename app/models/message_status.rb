class MessageStatus < ApplicationRecord
  belongs_to :message
  belongs_to :recipient
  belongs_to :user

  validates :status, presence: true, inclusion: { in: %w(new failed delivered) }
end
