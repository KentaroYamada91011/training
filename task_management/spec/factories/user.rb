FactoryBot.define do
  factory :user do
    sequence(:user_name) { |n| "user#{n}"}
    sequence(:mail_address) { |n| "user#{n}@example.com"}
    sequence(:password) { |n| "password#{n}"}
    admin false
  end
end
