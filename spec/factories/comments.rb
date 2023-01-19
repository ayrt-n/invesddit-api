FactoryBot.define do
  factory :comment do
    body { Faker::Lorem.sentence(word_count: 3) }
  end
end
