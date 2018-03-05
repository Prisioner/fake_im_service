class FakeIMClient
  def self.execute(message_status)
    new(message_status).send!
  end

  def initialize(message_status)
    @message_status = message_status
    # @body = message_status.message.body
    # @uid = message_status.recipient.uid
  end

  def send!
    # взаимодействие с внешним API и отправка запроса
    @result = result

    @status = @result[:code] == '200' ? :delivered : :failed

    @message_status.update(status: @status, details: @result)
  end

  private

  def result
    r = roll_result

    if r < 5
      {
        code: '404',
        info: 'user not found'
      }
    elsif r < 10
      {
        code: '403',
        info: 'account suspended'
      }
    else
      {
        code: '200',
        info: 'ok'
      }
    end
  end

  def roll_result
    rand(100)
  end
end
