# frozen_string_literal: true
module UserAuthenticationConcern
  extend ActiveSupport::Concern
  include Devise::SignInCallbacks

  included do
    # Include default devise modules. Others available are:
    # :validatable, :confirmable, :lockable, :timeoutable and :omniauthable
    devise :multi_email_authenticatable, :multi_email_confirmable, :multi_email_validatable,
           :registerable, :recoverable, :rememberable, :trackable, :masqueradable

    before_sign_in :create_instance_user, unless: :administrator?
    after_create :create_instance_user

    include UserOmniauthConcern
    include ReplacementMethods
  end

  private

  def create_instance_user
    if persisted? && instance_users.empty?
      @instance_role ||= "normal"
      instance_users.create(role: @instance_role)
    end
  end

  module ReplacementMethods
    # Overrides `Devise::Models::Validatable`
    # This disables the devise email validation for system user.
    def email_required?
      built_in? ? false : super
    end

    # Overrides `Devise::Models::Validatable`
    # This disables the devise password validation for system user.
    def password_required?
      built_in? ? false : super
    end
  end
end
