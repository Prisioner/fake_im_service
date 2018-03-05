class Api::V1::BaseController < ActionController::Base
  before_action :authenticate_request

  attr_reader :current_user

  respond_to :json

  protected

  rescue_from ActiveRecord::RecordNotFound do |e|
    respond_to do |format|
      format.json { render json: { code: 404, errors: [e.message] }, status: :not_found }
    end
  end

  rescue_from Apipie::ParamMissing, Apipie::ParamInvalid do |e|
    respond_to do |format|
      format.json { render json: { code: 422, errors: [e.message] }, status: :unprocessable_entity }
    end
  end

  def authenticate_request
    @current_user = AuthorizeApiRequest.call(request.headers).result

    render json: { code: 401, errors: [I18n.t('doc.v1.authentication.errors.not_authorized')] }, status: 401 unless @current_user
  end
end
