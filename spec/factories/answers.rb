FactoryBot.define do
  factory :answer do
    user
    question

    body { "MyAnswerBody" }

    trait :invalid do
      body { nil }
    end
  end
end
