class Api::V1::AuthenticationController < Api::V1::BaseController
  skip_before_action :authenticate_request

  resource_description do
    formats ['json']
    error 401, 'Invalid credentials'
    error 422, 'Validation error'
  end

  api :POST, '/v1/authenticate', I18n.t('doc.v1.authenticate')
  param :email, String, required: true, desc: 'Email for login'
  param :password, String, required: true, desc: 'Password for login'
  example <<-EXAMPLE
    {
      'code': 200,
      'auth_token': 'xxxxxxxxxxxx.xxxxxxxxxxxxxx.xxxxxxxxxxxxxx'
    }
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
