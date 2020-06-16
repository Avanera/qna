FactoryBot.define do
  sequence :email do |n|
    "user#{n}@test.com"
  end

  factory :user do
    # generating has_many questions
    transient do
      questions_count { 5 }
    end

    email
    password { '12345678' }
    password_confirmation { '12345678' }
  end
end
