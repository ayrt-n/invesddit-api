FactoryBot.define do
  factory :post do
    # Post associations
    association :account, status: :verified
    association :community

    # Post attributes to build
    title { Faker::Finance.stock_market }
    body { Faker::Lorem.paragraph }
    cached_score { 0 }
    cached_hot_rank { 0 }
    status { 'published' }

    # Make text post by default
    type { 'TextPost' }
  end
end
