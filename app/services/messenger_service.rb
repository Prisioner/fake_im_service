class MessengerService
  def self.execute(message_status)
    case message_status.recipient.im
    when 'telegram'
      TelegramClient.execute(message_status)
    when 'viber'
      ViberClient.execute(message_status)
    when 'whatsapp'
      WhatsappClient.execute(message_status)
    else
      message_status.update(status: :failed, details: { code: '422', info: 'Unknown IM service' })
    end
  end
end
