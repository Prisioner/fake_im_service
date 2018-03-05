class Recipient < ApplicationRecord
  has_many :message_statuses
  has_many :messages, through: :message_statuses, source: :message

  IM_SERVICES = %w(whatsapp telegram viber)

  validates :uid, presence: true
  validates :im, presence: true, inclusion: { in: IM_SERVICES }
  validates :uid, uniqueness: { scope: :im }
end
