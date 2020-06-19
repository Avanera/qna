FactoryBot.define do
  sequence :body do |n|
    "MyQuestionBody#{n}"
  end
  sequence :title do |n|
    "MyQuestionTitle#{n}"
  end

  factory :question do
    user
    title
    body

    trait :invalid do
      title { nil }
    end
  end
end
