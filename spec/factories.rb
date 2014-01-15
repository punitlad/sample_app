FactoryGirl.define do 
  factory :user do
    name 'Test User'
    email 'testuser@email.com'
    password 'password123'
    password_confirmation 'password123'
  end
end