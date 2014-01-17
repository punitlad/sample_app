FactoryGirl.define do 
  factory :user do
    sequence(:name) { |n| "Person #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com" }
    password 'password123'
    password_confirmation 'password123'

    trait :as_admin do
      admin true
    end
  end
end