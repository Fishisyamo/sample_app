FactoryBot.define do
  factory :user do
    name 'Michael Example'
    sequence(:email) { |n| "tester#{n}@example.com" }
    password 'password'
  end
end
