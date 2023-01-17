FactoryBot.define do
  factory :community do
    sub_dir { Faker::Finance.unique.stock_market }
  end
end
