FactoryBot.define do
  factory :answer do
    body { "MyAnswerBody" }

    trait :invalid do
      body { nil }
    end
  end
end
