class Api::V1::MessageStatusesController < Api::V1::BaseController
  before_action :set_message_status, only: [:show]
  before_action :authorize_user, only: [:show]

  resource_description do
    formats ['json']
    error 401, I18n.t('doc.v1.authentication.errors.not_authorized')
    error 403, I18n.t('doc.v1.message_statuses.errors.e403')
    error 404, I18n.t('doc.v1.message_statuses.errors.e404')
  end

  api :GET, '/v1/message_statuses/:id', I18n.t('doc.v1.message_statuses.show')
  param :id, :number, required: true, desc: I18n.t('doc.v1.message_statuses.id')
  example <<-EXAMPLE
    {
      'code': 200,
      'message_status': {
        'status': 'failed',
        'details': {
          'code': '403',
          'info': 'account suspended'
        }
        'recipient': { 'uid': '79123456789', 'im': 'viber' },
      }
    }
    ------------------------------
    {
      'code': 404,
      'errors': [
        "Couldn't find MessageStatus with 'id'=1"
      ]
    }
  EXAMPLE
  def show
    respond_to do |format|
      format.json { render json: { code: 200, message_status: MessageStatusSerializer.new(@message_status) }, status: 200 }
    end
  end

  private

  def authorize_user
    unless @message_status.user == current_user
      respond_to do |format|
        format.json { render json: { code: 403, errors: [I18n.t('doc.v1.message_statuses.errors.e403')] }, status: 403 }
      end
    end
  end

  def set_message_status
    @message_status = MessageStatus.includes(:recipient).find(params[:id])
  end
end
