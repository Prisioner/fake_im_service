require 'rails_helper'

RSpec.describe Api::V1::MessageStatusesController, type: :controller do
  let!(:user1) { create(:user) }
  let!(:user2) { create(:user) }
  let!(:status1) { create(:message_status, user: user1) }
  let!(:status2) { create(:message_status, user: user2) }

  describe 'GET #show' do
    context 'user not authorized' do
      before do
        get :show, params: { id: status1 }, format: :json
      end

      it 'returns code 401' do
        code = JSON.parse(response.body)['code']
        expect(code).to eq 401
        expect(response.code).to eq '401'
      end

      it 'returns error description' do
        errors = JSON.parse(response.body)['errors']
        expect(errors).to be
      end
    end

    context 'user authorized' do
      before do
        payload = { user_id: user1.id }
        token = JWT.encode(payload, Rails.application.secrets.secret_key_base)
        request.headers['Authorization'] = "Bearer #{token}"
      end

      context 'user tries to get own message status' do
        before { get :show, params: { id: status1 }, format: :json }

        it 'returns code 200' do
          code = JSON.parse(response.body)['code']
          expect(code).to eq 200
          expect(response.code).to eq '200'
        end

        it 'returns message status' do
          status = JSON.parse(response.body)['message_status']
          expect(status).to be
        end
      end

      context 'user tries to get foreign message status' do
        before { get :show, params: { id: status2 }, format: :json }

        it 'returns code 403' do
          code = JSON.parse(response.body)['code']
          expect(code).to eq 403
          expect(response.code).to eq '403'
        end

        it 'returns error description' do
          errors = JSON.parse(response.body)['errors']
          expect(errors).to be
        end
      end

      context 'user tries to get unexisted message status' do
        before { get :show, params: { id: MessageStatus.last.id + 1 }, format: :json }

        it 'returns code 404' do
          code = JSON.parse(response.body)['code']
          expect(code).to eq 404
          expect(response.code).to eq '404'
        end

        it 'returns error description' do
          errors = JSON.parse(response.body)['errors']
          expect(errors).to be
        end
      end
    end
  end
end
