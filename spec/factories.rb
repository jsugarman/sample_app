FactoryGirl.define do

  factory :user do
    # name     "Michael Hartl"
    # email    "michael@example.com"
    sequence(:name)  { |n| "Person #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com"}
    password "foobar"
    password_confirmation "foobar"
    activated true
    activated_at Time.zone.now

    factory :admin do
      admin true
    end
    
  end
  
  factory :micropost do
    content "lorem ipsem"
    user
  end

end