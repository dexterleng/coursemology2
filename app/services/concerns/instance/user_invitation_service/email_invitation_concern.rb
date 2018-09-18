# frozen_string_literal: true

# This concern deals with the sending of user invitation emails.
class Instance::UserInvitationService; end
module Instance::UserInvitationService::EmailInvitationConcern
  extend ActiveSupport::Autoload

  private

  def send_invitation_emails(invitation)
    Instance::Mailer.user_invitation_email(@current_instance, invitation).deliver_later
    Instance::UserInvitation.find_by(id: invitation.id).update(sent_at: Time.zone.now)
    puts Instance::UserInvitation.all
    true
  end
end
