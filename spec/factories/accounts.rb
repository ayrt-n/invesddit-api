FactoryBot.define do
  factory :account do
    # Default accounts to be verified
    verified

    # Set fake email and password
    email { Faker::Internet.email }
    username { Faker::Internet.username(separators: %w[_], specifier: 3..20) }
    password { Faker::Internet.password }

    # Traits to set account to verified/unverified
    trait :verified do
      status { 'verified' }
    end

    trait :unverified do
      status { 'unverified' }
    end
  end
end
