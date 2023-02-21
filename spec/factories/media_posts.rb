FactoryBot.define do
  factory :media_post do
    # Post associations
    association :account, status: :verified
    association :community

    # Post attributes to build
    title { Faker::Finance.stock_market }
    body { Faker::Lorem.paragraph }
    cached_score { 0 }
    cached_hot_rank { 0 }

    after(:build) do |media_post|
      media_post.image.attach(
        io: File.open(Rails.root.join('spec', 'fixtures', 'files', 'test.jpeg')),
        filename: 'test.jpeg',
        content_type: 'image/jpeg'
      )
    end
  end
end
