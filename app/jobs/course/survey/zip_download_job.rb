# frozen_string_literal: true
class Course::Survey::ZipDownloadJob < ApplicationJob
  include TrackableJob
  queue_as :lowest

  protected

  # Performs the download service.
  #
  # @param [Course::Survey] survey
  def perform_tracked(survey)
    zip_file = Course::Survey::ZipDownloadService.download_and_zip(survey)
    redirect_to SendFile.send_file(zip_file, Pathname.normalize_filename(survey.title) + '.zip')
  end
end
