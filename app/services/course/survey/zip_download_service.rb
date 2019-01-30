# frozen_string_literal: true
class Course::Survey::ZipDownloadService
  class << self
    # Downloads the survey in csv and zips it.
    #
    # @param [Course::Survey] survey The survey to be downloaded.
    # @return [String] The path to the zip file.
    def download_and_zip(survey)
      service = new(survey)
      ActsAsTenant.without_tenant do
        service.send(:download_to_base_dir)
      end
      service.send(:zip_base_dir)
    end
  end

  private

  def initialize(survey)
    @base_dir = Dir.mktmpdir('coursemology-download-')
    @survey = survey
    @survey_csv = Course::Survey::SurveyExportService.export(survey)
  end

  # Downloads the survey to its own folder in the base directory.
  def download_to_base_dir
    dst_path = File.join(@base_dir, "#{@survey.title}.csv")
    File.open(dst_path, 'w') do |dst_file|
      dst_file.write(@survey_csv)
    end
  end

  # Zip the directory and write to the file.
  #
  # @return [String] The path to the zip file.
  def zip_base_dir
    output_file = @base_dir + '.zip'
    Zip::File.open(output_file, Zip::File::CREATE) do |zip_file|
      Dir["#{@base_dir}/**/**"].each do |file|
        zip_file.add(file.sub(File.join(@base_dir + '/'), ''), file)
      end
    end

    output_file
  end
end
