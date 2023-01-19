FactoryBot.define do
  factory :comment do
    body { Faker::Lorem.sentence(word_count: 3) }
    association :account, status: :verified

    trait :for_post do
      association :commentable, factory: :post
    end

    trait :for_comment do
      association :commentable, factory: :comment
    end
  end
end
