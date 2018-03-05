require 'rails_helper'

RSpec.describe MessageStatus, type: :model do
  describe 'associations check' do
    it { should belong_to :recipient }
    it { should belong_to :message }
    it { should belong_to :user }
  end

  describe 'validations check' do
    it { should validate_presence_of :status }
    it { should validate_inclusion_of(:status).in_array(%w(new failed delivered)) }
  end
end
