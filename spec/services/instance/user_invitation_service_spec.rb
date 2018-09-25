# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Instance::UserInvitationService, type: :service do
  let(:instance) { create(:instance) }
  with_tenant(:instance) do
    let(:user) { create(:user) }

    let(:user_with_no_instance) do
      instance.instance_users.where(user: user).destroy_all
      user
    end

    def to_hash(user)
      { name: user.name, email: user.email, role: "normal" }
    end

    subject { Instance::UserInvitationService.new(user, instance) }

    describe '#invite' do
      context 'when user is not registered' do
        it 'succeeds' do
          user_hash = { name: "adfsadf", email: "unregistered@gmail.com", role: "normal" }
          expect(subject.invite(user_hash)).to be true
        end

        context 'when email is capitalized' do
          it 'downcases invitation email' do
            user_hash = { name: "adfsadf", email: "UNREGISTERED@gmail.com", role: "normal" }
            subject.invite(user_hash)
            invitation = instance.invitations.find_by(email: user_hash[:email].downcase)
            expect(invitation).not_to be nil
          end
        end
      end

      context 'when user is registered but not in current instance' do
        it 'succeeds' do
          # instance.instance_users.where(user: user).destroy_all
          expect(instance.instance_users.exists?(user: user_with_no_instance)).to be false
          user_hash = to_hash(user_with_no_instance)
          expect(subject.invite(user_hash)).to be true
        end
      end

      context 'when invitation already exists' do
        it 'fails' do
          user_hash = to_hash(user)
          subject.invite(user_hash)
          expect(subject.invite(user_hash)).to be false
        end
      end

      context 'when user is already in the current instance' do
        it 'fails' do
          user_hash = to_hash(user)
          expect(subject.invite(user_hash)).to be false
        end
      end
    end

    describe '#invite_new_user' do
      let(:new_user) do
        { name: "adfsadf", email: "unregistered@gmail.com", role: "normal" }
      end

      context 'when user attributes are valid' do
        it 'creates a user invitation' do
          subject.invite_new_user(new_user)
          invitation = instance.invitations.find_by(email: new_user[:email])
          expect(invitation).not_to be nil
          expect(invitation.role).to eq new_user[:role]
          expect(invitation.name).to eq new_user[:name]
        end

        with_active_job_queue_adapter(:test) do
          it 'sends an invitation email' do
            expect { subject.invite_new_user(new_user) }.to change { ActionMailer::Base.deliveries.count }.by(1)
          end
        end
      end

      context 'when email is invalid' do
        it 'fails' do
          invalid_email_user_hash = { name: "adfsadf", email: "blah", role: "normal" }
          success = subject.invite_new_user(invalid_email_user_hash)
          expect(success).to be false
        end
      end

      context 'when no roles are specified' do
        it 'defaults to :normal' do
          user_hash_with_no_role = { name: "adfsadf", email: "unregistered@gmail.com" }
          subject.invite_new_user(user_hash_with_no_role)
          invitation = instance.invitations.find_by(email: user_hash_with_no_role[:email])
          expect(invitation).not_to be nil
          expect(invitation.normal?).to be true
        end
      end
    end

    describe '#invite_registered_user' do
      context 'user is already registered' do
        it 'creates instance user immediately' do
          expect(instance.instance_users.exists?(user: user_with_no_instance)).to be false
          user_hash = to_hash(user_with_no_instance)
          subject.invite_registered_user(user_hash)
          found_user = instance.instance_users.find_by(user: user_with_no_instance)
          expect(found_user).not_to be_nil
        end

        with_active_job_queue_adapter(:test) do
          it 'sends a registration email' do
            expect { subject.invite_registered_user(to_hash(user_with_no_instance)) }.to change { ActionMailer::Base.deliveries.count }.by(1)
          end
        end
      end
    end
  end
end