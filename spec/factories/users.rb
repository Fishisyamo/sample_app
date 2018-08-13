FactoryBot.define do
  factory :user do
    name 'Michael Example'
    sequence(:email) { |n| "tester#{n}@example.com" }
    password 'password'
    activated true
    activated_at Time.zone.now
  end
end
