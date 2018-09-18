# frozen_string_literal: true

# Provides a service object for inviting users into a course.
class Instance::UserInvitationService
    include ParseInvitationConcern
    include ProcessInvitationConcern
    include EmailInvitationConcern
  
    # Constructor for the user invitation service object.
    #
    # @param [User] current_user The user performing this action.
    # @param [Course] current_course The course to invite users to.
    def initialize(current_user, current_instance)
      @current_user = current_user
      @current_instance = current_instance
    end
  
    # Invites users to the given course.
    #
    # The result of the transaction is both saving the course as well as validating validity
    # because Rails does not handle duplicate nested attribute uniqueness constraints.
    #
    # @param [Array<Hash>|File|TempFile] users Invites the given users.
    # @return [Array<Integer>|nil] An array containing the the size of new_invitations, existing_invitations,
    #   new_course_users and existing_course_users respectively if success. nil when fail.
    # @raise [CSV::MalformedCSVError] When the file provided is invalid.
    def invite(user)
      user = parse_invitation(user)
      if User::Email.exists?(email: user[:email])
        puts "user with that email already exists"
      elsif Instance::UserInvitation.exists?(email: user[:email])
        puts "Invite with that email already exists"
      else
        invitation = nil
        success = Instance.transaction do
          invitation = @current_instance.invitations.build(email: user[:email], name: user[:name], role: user[:role])
          invitation.save!
          true
        end
        puts Instance::UserInvitation.all
        send_invitation_emails(invitation) if success 
        
      end
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
  