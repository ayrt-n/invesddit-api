FactoryBot.define do
  factory :community do
    sub_dir { Faker::Finance.ticker }
  end
end
