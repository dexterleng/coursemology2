# frozen_string_literal: true

# Provides a service object for inviting users into a course.
class Instance::UserInvitationService
    include ParseInvitationConcern
    include EmailInvitationConcern
  
    # Constructor for the user invitation service object.
    #
    # @param [User] current_user The user performing this action.
    # @param [Instance] current_instance The instance to invite users to.
    def initialize(current_user, current_instance)
      @current_user = current_user
      @current_instance = current_instance
    end
  
    # Invites users to the given instance.
    #
    #
    # @param [Hash] user Invites the given user.
    # @return [Boolean] true if instance_user or invitation successfully created.
    # false otherwise, indicating presence of an error message.
    def invite(user)
      user = parse_invitation(user)
      user_exists?(user) ? invite_registered_user(user) : invite_new_user(user)
    end

    def user_exists?(user)
      User::Email.exists?(email: user[:email])
    end

    # Invites users that are not registered.
    #
    #
    # @param [Hash] user Invites the given user.
    # @return [Boolean] true if the invitation is valid and false otherwise
    # false is returned when invitation with the email already exists.
    def invite_new_user(user)
      invitation = nil
      success = Instance.transaction do
        invitation = @current_instance.invitations.build(email: user[:email], name: user[:name], role: user[:role])
        invitation.save
      end
      send_invitation_email(invitation) if success 
      success
    end

    # Invites users that are not registered.
    #
    #
    # @param [Hash] user Invites the given user.
    # @return [Boolean] true if the instance_user is valid and false otherwise
    # false is returned when user already exists in the current instance.
    def invite_registered_user(user)
      instance_user = nil
      success = Instance.transaction do
        instance_user = @current_instance.instance_users.build(user: User.with_email_address([user[:email]]), role: user[:role])
        instance_user.save
      end
      send_registered_email(instance_user) if success
      success
    end
  
    # Resends invitation emails to CourseUsers to the given course.
    # This method disregards CourseUsers that do not have an 'invited' status.
    #
    # @param [Array<Course::UserInvitation>] invitations An array of invitations to be resent.
    # @return [Boolean] True if there were no errors in sending invitations.
    #   If all provided CourseUsers have already registered, method also returns true.
    def resend_invitation(invitations)
      invitations.blank? ? true : send_invitation_emails(invitations)
    end


  
  end
  