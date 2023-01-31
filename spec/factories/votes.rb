FactoryBot.define do
  factory :vote do
    for_post
    association :account, status: :verified
    type { 1 }

    trait :for_post do
      association :votable, factory: :post
    end

    trait :for_comment do
      association :votable, factory: :comment
    end
  end
end
