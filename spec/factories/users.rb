FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    after(:build) { |user| user.password = '12345678' }
  end
end
