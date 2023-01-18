FactoryBot.define do
  factory :community do
    sub_dir { Faker::Alphanumeric.unique.alpha(number: 20) }
  end
end
