FactoryBot.define do
  factory :question do
    # generating has_many answers
    transient do
      answers_count { 5 }
    end

    title { "MyString" }
    body { "MyText" }

    trait :invalid do
      title { nil }
    end
  end
end
