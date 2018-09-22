# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Instance::UserInvitationService, type: :service do
  let(:instance) { create(:instance) }
  with_tenant(:instance) do
    let(:user) { create(:user) }

    subject { Instance::UserInvitationService.new(user, instance) }

    describe '#invite' do
      context 'when user is not registered' do
        it 'succeeds' do
          user_hash = { name: "adfsadf", email: "unregistered@gmail.com", role: "normal" }
          expect(subject.invite(user_hash)).to be true
        end
      end

      context 'when user is registered but not in current instance' do
        it 'succeeds' do
          user = create(:user)
          instance.instance_users.where(user: user).destroy_all
          expect(instance.instance_users.exists?(user: user)).to be false
          user_hash = { name: user.name, email: user.email, role: "normal" }
          expect(subject.invite(user_hash)).to be true
        end
      end

      context 'when invitation already exists' do
        it 'fails' do
          user_hash = user_hash = { name: user.name, email: user.email, role: "normal" }
          subject.invite(user_hash)
          expect(subject.invite(user_hash)).to be false
        end
      end
    end

    # describe '#invite_new_user' do
    #   let(:new_user) do
    #     { name: "adfsadf", email: "unregistered@gmail.com", role: "normal" }
    #   end

    #   let(:another_new_user) do
    #     { name: "adfsadf", email: "unregistered_another@gmail.com", role: "normal" }
    #   end

    #   context 'user is valid' do
    #     it 'creates a user invitation' do
    #       subject.invite_new_user(new_user)
    #       expect(instance.invitations.any? do |invitation|
    #         invitation.email == new_user[:email]
    #       end)
    #     end

    #     with_active_job_queue_adapter(:test) do
    #       it 'sends an invitation email' do
    #         expect { subject.invite_new_user(another_new_user) }.to change { ActionMailer::Base.deliveries.count }.by(1)
    #       end
    #     end
    #   end
    # end

    # describe '#invite_registered_user' do
    #   context 'user is already registered' do
    #     it 'creates instance user immediately' do
    #       user = create(:user)
    #       puts User.with_email_address(user.email).inspect
    #       user_hash = { name: user.name, email: user.email, role: "normal" }
    #       puts user_hash
    #       subject.invite_registered_user(user_hash)
    #       found_user = instance.instance_users.find(user: user)
    #       expect(found_user).not_to be_nil
    #     end
    #   end
    # end
  end
end