require 'rails_helper'

RSpec.describe Account, type: :model do
  it { is_expected.to validate_presence_of(:username) }
  it { is_expected.to validate_length_of(:username).is_at_least(3).is_at_most(20) }
  it { is_expected.to validate_content_type_of(:avatar).allowing('image/png', 'image/jpeg') }
  it { is_expected.to validate_content_type_of(:banner).allowing('image/png', 'image/jpeg') }
  it { is_expected.to validate_size_of(:avatar).less_than(2.megabytes) }
  it { is_expected.to validate_size_of(:banner).less_than(5.megabytes) }

  context '#join_community' do
    it 'creates membership for account and community' do
      account = create(:account)
      community = create(:community)

      account.join_community(community)

      expect(Membership.where(account:, community:)).to exist
    end
  end
end
