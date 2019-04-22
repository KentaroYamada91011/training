FactoryBot.define do
  factory :task do
    sequence(:name) { |n| "name_#{n}" }
    sequence(:content) { |n| "dummy content_#{n}" }
    sequence(:status) { 0 }
    sequence(:created_at) { |n|
      today = Time.zone.now + n * 10
    }
    sequence(:expire_date) { |n|
      today = Time.zone.today + n * 3
    }
  end
end
