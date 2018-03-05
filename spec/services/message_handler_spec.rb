require 'rails_helper'

RSpec.describe MessageHandler do
  let!(:message_params) { { body: 'some text', recipients: [{uid: '79123456789', im: 'telegram'}] } }
  let!(:user) { create(:user) }
  let!(:valid_handler) { MessageHandler.new(message_params, user) }

  describe 'validations' do
    it 'everything ok' do
      expect(valid_handler).to be_valid
    end

    it 'should validate presence of body' do
      message_params.delete(:body)
      handler = MessageHandler.new(message_params, user)

      expect(handler).to_not be_valid
      expect(handler.errors[:body]).to be
    end

    it 'should validate presense of recipients uid' do
      message_params[:recipients].first[:uid] = nil
      handler = MessageHandler.new(message_params, user)

      expect(handler).to_not be_valid
      expect(handler.errors[:base]).to be
    end

    it 'should validate presense of recipients im' do
      message_params[:recipients].first[:im] = nil
      handler = MessageHandler.new(message_params, user)

      expect(handler).to_not be_valid
      expect(handler.errors[:base]).to be
    end
  end

  describe '#create_message' do
    context 'recipient and message not found in database' do
      it 'creates new message in database' do
        expect { valid_handler.create_message }.to change(Message, :count).by(1)
      end

      it 'creates new recipient in database' do
        expect { valid_handler.create_message }.to change(Recipient, :count).by(1)
      end

      it 'creates new message status in database' do
        expect { valid_handler.create_message }.to change(MessageStatus, :count).by(1)
      end
    end

    context 'recipient and message was founded in database' do
      before do
        valid_handler.create_message
      end

      it 'does not create new messages in database' do
        expect { valid_handler.create_message }.to_not change(Message, :count)
      end

      it 'does not create new recipients in database' do
        expect { valid_handler.create_message }.to_not change(Recipient, :count)
      end

      it 'creates new message status in database' do
        expect { valid_handler.create_message }.to change(MessageStatus, :count).by(1)
      end
    end
  end
end
