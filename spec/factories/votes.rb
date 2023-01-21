FactoryBot.define do
  factory :vote do
    association :account, status: :verified
    vote { 1 }

    trait :for_post do
      association :votable, factory: :post
    end

    trait :for_comment do
      association :votable, factory: :comment
    end
  end
end
