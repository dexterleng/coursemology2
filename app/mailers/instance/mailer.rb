class Instance::Mailer < ApplicationMailer
  # Sends an invitation email for the given invitation.
  #
  # @param [Instance] instance The course that was involved.
  # @param [Instance::UserInvitation] invitation The invitation which was generated.
  def user_invitation_email(instance, invitation)
    @instance = instance
    @invitation = invitation
    @recipient = invitation

    mail(to: invitation.email, subject: t('.subject', instance: @instance.name, role: invitation.role))
  end

  def user_added_email(instance, user)
    @instance = instance
    @recipient = user.user

    mail(to: @recipient.email, subject: t('.subject', instance: @instance.name))
  end
end
