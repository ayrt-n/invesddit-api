FactoryBot.define do
  factory :membership do
    association :account
    association :community

    role { 1 }
  end
end
