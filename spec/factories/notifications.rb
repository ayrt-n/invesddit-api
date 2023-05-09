FactoryBot.define do
  factory :notification do
    comment_response
    association :account, status: :verified
    read { false }

    trait :comment_response do
      association :notifiable, factory: :comment
    end
  end
end
