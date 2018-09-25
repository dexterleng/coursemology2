# frozen_string_literal: true
class System::Admin::Instance::UsersController < System::Admin::Instance::Controller
  load_and_authorize_resource :instance_user, class: InstanceUser.name,
                                              parent: false, except: [:index, :new, :create]
  add_breadcrumb :index, :admin_instance_users_path

  def index
    load_instance_users
    load_counts
  end

  def new
    @invite = @instance.invitations.build
  end

  def create
    #result = invite
    #@invite = @instance.invitations.build(instance_user_invitation_params)
    result = invite
    if result
      redirect_to admin_instance_users_path, success: t('.success')
    else
      redirect_to new_admin_instance_user_path, danger: create_form_error_message
    end
  end

  def update
    if @instance_user.update_attributes(instance_user_params)
      flash.now[:success] = t('.success', user: @instance_user.user.name)
    else
      flash.now[:danger] = @instance_user.errors.full_messages.to_sentence
    end
  end

  def destroy
    if @instance_user.destroy
      redirect_to admin_instance_users_path, success: t('.success', user: @instance_user.user.name)
    else
      redirect_to admin_instance_users_path, danger: @instance_user.errors.full_messages.to_sentence
    end
  end

  private

  def load_instance_users
    @instance_users = @instance.instance_users.includes(user: [:emails, :courses]).
                      page(page_param).search_and_ordered_by_username(search_param)
    @instance_users = @instance_users.active_in_past_7_days if params[:active]
    @instance_users = @instance_users.where(role: params[:role]) \
      if params[:role] && InstanceUser.roles.key?(params[:role])
  end

  def load_counts
    @counts = {
      total: current_tenant.instance_users.group(:role).count,
      active: current_tenant.instance_users.active_in_past_7_days.group(:role).count
    }.with_indifferent_access
  end

  def instance_user_params
    puts "params gay"
    puts params
    params.require(:instance_user).permit(:role)
  end

  def search_param
    params.permit(:search)[:search]
  end

  # Invites the users via the service object.
  #
  # @return [Boolean] True if the invitation was successful.
  def invite
    invitation_service.invite(instance_user_invitation_params)
  end

  def invitation_service
    @invitation_service ||= Instance::UserInvitationService.new(current_instance_user, @instance)
  end

  def instance_user_invitation_params # :nodoc:
    # puts "yo gobba"
    # puts params
    # @instance_user_invitation_params ||= begin
    #   params[:instance] = { invitations_attributes: {} } unless params.key?(:instance)

    #   params.require(:instance).permit(:invitations_file, :registration_key,
    #                                  invitations_attributes: [:name, :email, :role])
    # end
    params.require(:user_invitation).permit(:name, :email, :role)
  end

  def create_form_error_message
    invitation_error = @instance.invitations.reject(&:valid?).first&.errors&.full_messages&.to_sentence
    instance_user_error = @instance.instance_users.reject(&:valid?).first&.errors&.full_messages&.to_sentence
    invitation_error || instance_user_error
  end

end
