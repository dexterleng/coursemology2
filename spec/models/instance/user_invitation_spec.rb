require 'rails_helper'

RSpec.describe Instance::UserInvitation, type: :model do
  describe '#generate_invitation_key' do
    it 'starts with "J"' do
      expect(subject.invitation_key).to start_with('J')
    end
  end
end
