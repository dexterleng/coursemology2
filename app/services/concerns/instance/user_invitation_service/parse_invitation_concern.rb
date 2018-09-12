# frozen_string_literal: true
require 'csv'

# This concern includes methods required to parse the invitations data.
# This can either be from a form, or a CSV file.
class Instance::UserInvitationService; end
module Instance::UserInvitationService::ParseInvitationConcern
  extend ActiveSupport::Autoload

  TRUE_VALUES = ['t', 'true', 'y', 'yes'].freeze

  private

  def parse_invitations_from_form(users)
    users.map do |(_, value)|
      name = value[:name].presence || value[:email]
      phantom = ActiveRecord::Type::Boolean.new.cast(value[:phantom])
      { name: name, email: value[:email].downcase, role: value[:role], phantom: phantom }
    end
  end

end
