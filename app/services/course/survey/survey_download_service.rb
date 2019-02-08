# frozen_string_literal: true
class Course::Survey::SurveyDownloadService
  class << self
    # Downloads the survey in csv.
    #
    # @param [Course::Survey] survey The survey to be downloaded.
    # @return [String] The path to the csv file.
    def download(survey)
      service = new(survey)
      ActsAsTenant.without_tenant do
        service.send(:download_to_base_dir)
      end
    end
  end

  private

  def initialize(survey)
    @base_dir = Dir.mktmpdir('coursemology-survey-')
    @survey = survey
    @survey_csv = Course::Survey::SurveyExportService.export(survey)
  end

  # Downloads the survey to its own folder in the base directory.
  #
  # @return [String] The path to the csv file.
  def download_to_base_dir
    dst_path = File.join(@base_dir, "#{@survey.title}.csv")
    File.open(dst_path, 'w') do |dst_file|
      dst_file.write(@survey_csv)
    end
    dst_path
  end
end
