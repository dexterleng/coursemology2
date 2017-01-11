# frozen_string_literal: true
class Course::Video::Submission::SubmissionsController < Course::Video::Submission::Controller
  before_action :authorize_video!, only: :create

  def index
    authorize!(:manage, @video)
    @submissions = @submissions.includes(experience_points_record: :course_user)
    @my_students = current_course_user.try(:my_students) || []
    @course_students = current_course.course_users.students.order_alphabetically
  end

  def create
    if @submission.save
      redirect_to edit_course_video_submission_path(current_course, @video, @submission)
    else
      redirect_to course_videos_path(current_course),
                  danger: t('.failure', error: @submission.errors.full_messages.to_sentence)
    end
  end

  def edit; end

  private

  def create_params
    { course_user: current_course_user }
  end

  def authorize_video!
    authorize!(:attempt, @video)
  end
end
