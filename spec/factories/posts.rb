FactoryBot.define do
  factory :post do
    # Post associations
    association :account, status: :verified
    association :community

    # Post attributes to build
    title { Faker::Finance.stock_market }
    body { Faker::Lorem.paragraph }
  end
end
