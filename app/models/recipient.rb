class Recipient < ApplicationRecord
  has_many :message_statuses
  has_many :messages, through: :message_statuses, source: :message

  validates :uid, presence: true
  validates :im, presence: true, inclusion: { in: %w(whatsapp telegram viber) }
  validates :uid, uniqueness: { scope: :im }
end
