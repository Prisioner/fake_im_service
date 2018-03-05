class Api::V1::AuthenticationController < Api::V1::BaseController
  skip_before_action :authenticate_request

  resource_description do
    formats ['json']
    error 401, I18n.t('doc.v1.authentication.errors.e401')
    error 422, I18n.t('doc.v1.authentication.errors.e422')
  end

  api :POST, '/v1/authenticate', I18n.t('doc.v1.authentication.authenticate')
  param :email, String, required: true, desc: I18n.t('doc.v1.authentication.email')
  param :password, String, required: true, desc: I18n.t('doc.v1.authentication.password')
  description "Allow to recieve authorization token for other API methods. Use header 'Authorization: Bearer %token%'"
  example <<-EXAMPLE
    {
      'code': 200,
      'auth_token': 'xxxxxxxxxxxx.xxxxxxxxxxxxxx.xxxxxxxxxxxxxx'
    }
    ------------------------------
    {
      'code': 422,
      'errors': [
        'Missing parameter password'
      ]
    }
  EXAMPLE
  def authenticate
    command = AuthenticateUser.call(params[:email], params[:password])

    if command.success?
      render json: { code: 200, auth_token: command.result }
    else
      render json: { code: 401, errors: [command.errors] }, status: :unauthorized
    end
  end
end
