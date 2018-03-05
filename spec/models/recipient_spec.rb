require 'rails_helper'

RSpec.describe Recipient, type: :model do
  describe 'associations check' do
    it { should have_many :messages }
    it { should have_many :message_statuses }
  end

  describe 'validations check' do
    it { should validate_presence_of :uid }
    it { should validate_presence_of :im }
    it { should validate_uniqueness_of(:uid).scoped_to(:im) }
  end
end
