require 'rails_helper'

RSpec.describe Membership, type: :model do
  subject { create(:membership) }
  it { is_expected.to validate_uniqueness_of(:account).scoped_to(:community_id).with_message('is already a member') }
end
