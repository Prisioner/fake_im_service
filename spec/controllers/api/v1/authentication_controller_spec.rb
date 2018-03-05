require 'rails_helper'

RSpec.describe Api::V1::AuthenticationController, type: :controller do
  let!(:user) { create(:user, email: 'e@e.com', password: '12345678') }

  describe 'POST #authenticate' do
    context 'with valid params' do
      before do
        post :authenticate, params: { email: 'e@e.com', password: '12345678' }, format: :json
      end

      it 'returns auth token' do
        token = JSON.parse(response.body)['auth_token']
        expect(token).to be
      end

      it 'returns code 200' do
        code = JSON.parse(response.body)['code']
        expect(code).to eq 200
        expect(response.code).to eq '200'
      end
    end

    context 'with invalid params' do
      context 'invalid credentials' do
        before do
          post :authenticate, params: { email: 'e@e.com', password: 'qwerty123' }, format: :json
        end

        it 'does not return token' do
          token = JSON.parse(response.body)['auth_token']
          expect(token).to be_nil
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

      context 'missing params' do
        before do
          post :authenticate, params: {  }, format: :json
        end

        it 'does not return token' do
          token = JSON.parse(response.body)['auth_token']
          expect(token).to be_nil
        end

        it 'returns code 422' do
          code = JSON.parse(response.body)['code']
          expect(code).to eq 422
          expect(response.code).to eq '422'
        end

        it 'returns error description' do
          errors = JSON.parse(response.body)['errors']
          expect(errors).to be
        end
      end
    end
  end
end
