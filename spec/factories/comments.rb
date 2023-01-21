FactoryBot.define do
  factory :comment do
    # Default comments to use for_post trait
    for_post
    association :account, status: :verified

    # Fill comment body with lorem text
    body { Faker::Lorem.sentence(word_count: 3) }

    # Traits to set commentable to either post or comment
    trait :for_post do
      association :commentable, factory: :post
    end

    trait :for_comment do
      association :commentable, factory: :comment
    end
  end
end
