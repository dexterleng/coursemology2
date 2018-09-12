# frozen_string_literal: true

# This concern deals with the sending of user invitation emails.
class Instance::UserInvitationService; end
module Instance::UserInvitationService::EmailInvitationConcern
  extend ActiveSupport::Autoload

  private

  def send_invitation_emails(invitations)
    invitations.each do |invitation|
      Instance::Mailer.user_invitation_email(@current_instance, invitation).deliver_later
    end
    ids = invitations.select(&:id)
    Instance::UserInvitation.where(id: ids).update_all(sent_at: Time.zone.now)

    true
  end
end
