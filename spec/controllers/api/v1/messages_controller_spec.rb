require 'rails_helper'

RSpec.describe Api::V1::MessagesController, type: :controller do
  let!(:user) { create(:user) }
  let!(:message_params) { { body: 'some text', recipients: [{uid: '79123456789', im: 'telegram'}] } }

  describe 'POST #create' do
    context 'user not authorized' do
      it 'returns code 401' do
        post :create, params: { message: message_params }, format: :json

        code = JSON.parse(response.body)['code']
        expect(code).to eq 401
        expect(response.code).to eq '401'
      end

      it 'returns error description' do
        post :create, params: { message: message_params }, format: :json

        errors = JSON.parse(response.body)['errors']
        expect(errors).to be
      end

      it 'does not create Recipients in database' do
        expect { post :create, params: { message: message_params }, format: :json }.to_not change(Recipient, :count)
      end

      it 'does not create Messages in database' do
        expect { post :create, params: { message: message_params }, format: :json }.to_not change(Message, :count)
      end

      it 'does not create MessageStatuses in database' do
        expect { post :create, params: { message: message_params }, format: :json }.to_not change(MessageStatus, :count)
      end

      it 'does not enqueue SendMessageJob' do
        ActiveJob::Base.queue_adapter = :test
        expect { post :create, params: { message: message_params }, format: :json }.to_not have_enqueued_job(SendMessageJob)
      end
    end

    context 'user authorized' do
      before do
        payload = { user_id: user.id }
        token = JWT.encode(payload, Rails.application.secrets.secret_key_base)
        request.headers['Authorization'] = "Bearer #{token}"
      end

      context 'user posts valid params' do
        it 'returns code 200' do
          post :create, params: { message: message_params }, format: :json

          code = JSON.parse(response.body)['code']
          expect(code).to eq 200
          expect(response.code).to eq '200'
        end

        it 'returns messages' do
          post :create, params: { message: message_params }, format: :json

          messages = JSON.parse(response.body)['messages']
          expect(messages).to be
        end

        it 'creates Recipient in database' do
          expect { post :create, params: { message: message_params }, format: :json }.to change(Recipient, :count).by(1)
        end

        it 'creates Messag in database' do
          expect { post :create, params: { message: message_params }, format: :json }.to change(Message, :count).by(1)
        end

        it 'creates MessageStatus in database' do
          expect { post :create, params: { message: message_params }, format: :json }.to change(MessageStatus, :count).by(1)
        end

        it 'enqueue SendMessageJob' do
          ActiveJob::Base.queue_adapter = :test
          expect { post :create, params: { message: message_params }, format: :json }.to have_enqueued_job(SendMessageJob)
        end
      end

      context 'user posts invalid params' do
        let!(:message_params) { { recipients: [{uid: '79123456789', im: 'telegram'}] } }

        it 'returns code 422' do
          post :create, params: { message: message_params }, format: :json

          code = JSON.parse(response.body)['code']
          expect(code).to eq 422
          expect(response.code).to eq '422'
        end

        it 'returns error description' do
          post :create, params: { message: message_params }, format: :json

          errors = JSON.parse(response.body)['errors']
          expect(errors).to be
        end

        it 'does not create Recipients in database' do
          expect { post :create, params: { message: message_params }, format: :json }.to_not change(Recipient, :count)
        end

        it 'does not create Messages in database' do
          expect { post :create, params: { message: message_params }, format: :json }.to_not change(Message, :count)
        end

        it 'does not create MessageStatuses in database' do
          expect { post :create, params: { message: message_params }, format: :json }.to_not change(MessageStatus, :count)
        end

        it 'does not enqueue SendMessageJob' do
          ActiveJob::Base.queue_adapter = :test
          expect { post :create, params: { message: message_params }, format: :json }.to_not have_enqueued_job(SendMessageJob)
        end
      end
    end
  end
end
