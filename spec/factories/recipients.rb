FactoryBot.define do
  factory :recipient do
    uid { Faker::Number.number(10) }
    im 'telegram'
  end
end
