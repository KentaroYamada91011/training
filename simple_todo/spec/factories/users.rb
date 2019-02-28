FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "test user #{n}"}
    sequence(:email) { |n| "test#{n}@test.com"}
    password_digest {'password'}
    admin_flag {0}
  end
end
