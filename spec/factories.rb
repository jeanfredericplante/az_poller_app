FactoryGirl.define do
  factory :user do
    sequence(:name) { |n| "John #{n}" }
    sequence(:email) { |n| "user-#{n}@example.com" }
    password  "123123"
    password_confirmation "123123"
    factory :admin do
      admin true
    end
    
  end
  
  

end
