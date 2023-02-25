FactoryBot.define do
  factory :comment do
    # Associations (excluding replies)
    association :account, status: :verified
    association :post

    # Set reply association via id, default nil
    reply_id { nil }

    # Fill comment body with lorem text
    body { Faker::Lorem.sentence(word_count: 3) }
  end
end
