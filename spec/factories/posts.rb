FactoryBot.define do
  factory :post do
    title { Faker::Finance.stock_market }
    body { Faker::Lorem.paragraph }
  end
end
