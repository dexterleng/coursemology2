FactoryGirl.define do
  factory :generic_announcement, class: System::Announcement.name do
    sequence(:title) { |n| "Announcement #{n}" }
    sequence(:content) { |n| "Content #{n}" }

    start_at { Time.zone.now }
    end_at { start_at + 3.days }
  end
end
