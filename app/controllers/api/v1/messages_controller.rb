class Api::V1::MessagesController < Api::V1::BaseController
  resource_description do
    formats ['json']
    error 401, I18n.t('doc.v1.authentication.errors.not_authorized')
    error 422, I18n.t('doc.v1.messages.errors.e422')
  end

  api :POST, '/v1/messages', I18n.t('doc.v1.messages.create')
  param :message, Hash do
    param :body, String, required: true, desc: I18n.t('doc.v1.messages.body')
    param :send_at, String, desc: I18n.t('doc.v1.messages.send_at')
    param :recipients, Array, required: true, desc: I18n.t('doc.v1.messages.recipients') do
      param :uid, String, required: true, desc: I18n.t('doc.v1.messages.uid')
      param :im, Recipient::IM_SERVICES, required: true, desc: I18n.t('doc.v1.messages.im')
    end
  end
  example <<-EXAMPLE
    {
      'code': 200,
      'messages': [
        {'recipient': { 'uid': '79123456789', 'im': 'viber' }, 'message_status_id': 1},
        {'recipient': { 'uid': '79987654321', 'im': 'viber' }, 'message_status_id': 2}
      ]
    }
    ------------------------------
    {
      'code': 422,
      'errors': [
        'Missing parameter im'
      ]
    }
  EXAMPLE
  def create
    handler = MessageHandler.execute(message_params, current_user)

    respond_to do |format|
      if handler.valid?
        format.json { render json: { code: 200 }.merge(MessageHandlerSerializer.new(handler)), status: 200 }
      else
        format.json { render json: { code: 422, errors: handler.errors.full_messages }, status: 422 }
      end
    end
  end

  private

  def message_params
    params.require(:message).permit(:body, :send_at, recipients: %i[uid im])
  end
end
