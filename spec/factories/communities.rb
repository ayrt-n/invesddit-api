FactoryBot.define do
  factory :community do
    sub_dir { Faker::Finance.unique.ticker }
  end
end
