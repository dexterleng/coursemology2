# frozen_string_literal: true
require 'csv'

# This concern includes methods required to parse the invitations data.
# This can either be from a form, or a CSV file.
class Instance::UserInvitationService; end
module Instance::UserInvitationService::ParseInvitationConcern
  extend ActiveSupport::Autoload

  TRUE_VALUES = ['t', 'true', 'y', 'yes'].freeze

  private

  def parse_invitation(user)
    { name: user[:name], email: user[:email].downcase, role: user[:role]}
  end

end
