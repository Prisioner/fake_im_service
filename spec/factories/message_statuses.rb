FactoryBot.define do
  factory :message_status do
    status :new

    association :user
    association :recipient
    association :message
  end
end
