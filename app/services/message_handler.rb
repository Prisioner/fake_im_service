class MessageHandler
  include ActiveModel::Validations
  include ActiveModel::Serialization

  validates :body, presence: true
  validates_with RecipientsValidator

  attr_reader :body, :send_at, :recipients, :messages

  def self.execute(params, user)
    self.new(params, user).tap do |handler|
      handler.create_message
    end
  end

  def initialize(params, user)
    @body = params[:body]
    @send_at = datetime_by_timestamp(params[:send_at])
    @recipients = params[:recipients]
    @user = user
  end

  def create_message
    if valid?
      message = Message.find_or_create_by(body: @body)

      @messages = @recipients.map do |recipient|
        message_status = MessageStatus.create(
          user: @user,
          message: message,
          recipient: Recipient.find_or_create_by(recipient),
          status: :new
        )

        {
          recipient: recipient,
          message_status_id: message_status.id
        }
      end

      send_messages
    end
  end

  private

  def send_messages
    if @send_at
      @messages.each { |message| SendMessageJob.set(wait_until: @send_at).perform_later(message[:message_status_id]) }
    else
      @messages.each { |message| SendMessageJob.perform_later(message[:message_status_id]) }
    end
  end

  def datetime_by_timestamp(timestamp)
    begin
      datetime = Time.at(timestamp.to_i).to_datetime
      # accept only future datetime
      datetime if datetime > DateTime.current
    rescue ArgumentError
      nil
    end
  end
end
