FactoryBot.define do
  factory :membership do
    association :account
    association :community

    role { 1 }

    trait :is_admin do
      role { 2 }
    end
  end
end
