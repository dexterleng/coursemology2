# frozen_string_literal: true

# This concern deals with the sending of user invitation emails.
class Instance::UserInvitationService; end
module Instance::UserInvitationService::EmailInvitationConcern
  extend ActiveSupport::Autoload

  private

  def send_invitation_email(invitation)
    Instance::Mailer.user_invitation_email(@current_instance, invitation).deliver_later
    Instance::UserInvitation.find_by(id: invitation.id).update(sent_at: Time.zone.now)
    puts Instance::UserInvitation.all
    true
  end

  def send_registered_email(user)
    Instance::Mailer.user_added_email(@current_instance, user).deliver_later
    true
  end

end
