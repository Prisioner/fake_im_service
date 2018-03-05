class MessageStatusSerializer < ActiveModel::Serializer
  has_one :recipient
  has_one :message

  attributes :status, :details
end
