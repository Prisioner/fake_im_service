require 'rails_helper'

RSpec.describe Message, type: :model do
  describe 'associations check' do
    it { should have_many :statuses }
    it { should have_many :recipients }
  end

  describe 'validations check' do
    it { should validate_presence_of :body }
  end
end
