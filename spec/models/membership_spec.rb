require 'rails_helper'

RSpec.describe Membership, type: :model do
  # Validation tests

  context 'members counter cache' do
    before do
      @account = create(:account)
      @community = create(:community)
    end

    it 'calls increment on members count if membership is member role' do
      allow(@community).to receive(:increment!)
      Membership.create(account: @account, community: @community, role: 'member')

      expect(@community).to have_received(:increment!).with(:members_count)
    end

    it 'does not call increment if membership is not member role' do
      allow(@community).to receive(:increment!)
      Membership.create(account: @account, community: @community, role: 'admin')

      expect(@community).not_to have_received(:increment!)
    end

    it 'calls decrement on members count if membership is member role' do
      allow(@community).to receive(:increment!)
      allow(@community).to receive(:decrement!)

      membership = Membership.create(account: @account, community: @community, role: 'member')
      membership.destroy

      expect(@community).to have_received(:decrement!).with(:members_count)
    end

    it 'does not call decrement if membership is admin role' do
      allow(@community).to receive(:increment!)
      allow(@community).to receive(:decrement!)

      membership = Membership.create(account: @account, community: @community, role: 'admin')
      membership.destroy

      expect(@community).not_to have_received(:decrement!)
    end
  end
end
