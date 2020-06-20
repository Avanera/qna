FactoryBot.define do
  sequence :answer_body do |n|
    "MyAnswerBody#{n}"
  end

  factory :answer do
    user
    question

    body

    trait :invalid do
      body { nil }
    end
  end
end
