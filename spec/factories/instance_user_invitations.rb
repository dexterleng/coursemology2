FactoryBot.define do
  factory :instance_user_invitation, class: 'Instance::UserInvitation' do
    host "MyString"
    name "MyString"
    email "MyString"
    role 1
    invitation_key "MyString"
  end
end
