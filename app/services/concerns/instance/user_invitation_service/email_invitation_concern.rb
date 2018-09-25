# frozen_string_literal: true

# This concern deals with the sending of user invitation emails.
class Instance::UserInvitationService; end
module Instance::UserInvitationService::EmailInvitationConcern
  extend ActiveSupport::Autoload

  private

  # Sends invitation email. This method also updates the sent_at timing for the
  # Instance::UserInvitation object for tracking purposes.
  #
  # Note that since +deliver_later+ is used, this is an approximation on the time sent.
  #
  # @param [Instance::UserInvitation] invitation The invitation sent out to the user.
  # @return [Boolean] True if the invitation was updated.
  def send_invitation_email(invitation)
    Instance::Mailer.user_invitation_email(@current_instance, invitation).deliver_later
    Instance::UserInvitation.find_by(id: invitation.id).update(sent_at: Time.zone.now)
    true
  end

  # Sends registered email to the user invited.
  #
  # @param [InstanceUser] registered_user Users who were registered.
  # @return [Boolean] True if the email was dispatched.
  def send_registered_email(user)
    Instance::Mailer.user_added_email(@current_instance, user).deliver_later
    true
  end

end
