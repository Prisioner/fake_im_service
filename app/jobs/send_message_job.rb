class SendMessageJob < ApplicationJob
  queue_as :default

  def perform(message_status_id)
    message_status = MessageStatus.includes(:recipient).includes(:message).find(message_status_id)

    if duplicated_message?(message_status)
      message_status.update(status: :failed, details: { code: '422', info: I18n.t('errors.duplicated_message') })
    else
      MessengerService.execute(message_status)
    end
  end

  private

  def duplicated_message?(message_status)
    MessageStatus.where(
      message_id: message_status.message_id,
      user_id: message_status.user_id,
      recipient_id: message_status.recipient_id,
      status: :delivered
    ).where(
      'updated_at > ?', 30.minutes.ago
    ).where.not(
      id: message_status.id
    ).any?
  end
end
