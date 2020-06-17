FactoryBot.define do
  factory :question do
    user

    title { "MyQuestionTitle" }
    body { "MyQuestionBody" }

    trait :invalid do
      title { nil }
    end
  end
end
