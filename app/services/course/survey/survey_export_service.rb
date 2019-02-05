# frozen_string_literal: true
require 'csv'

class Course::Survey::SurveyExportService
  class << self
    # Converts survey to string csv format.
    #
    # @param [Course::Survey] survey The survey to be converted
    # @return [String] The survey in csv format.
    def export(survey)
      responses = Course::Survey::Response.
                  where.not(submitted_at: nil).
                  includes(answers: [:options, :question]).
                  where(survey: survey)
      questions = survey.questions.sort_by(&:weight)
      header = generate_header(questions)

      CSV.generate(headers: true, force_quotes: true) do |csv|
        csv << header
        responses.each do |response|
          csv << generate_row(response, questions)
        end
      end
    end

    private

    def generate_header(questions)
      ['Timestamp', 'Course User ID', 'Name', 'Role'] + questions.map(&:description)
    end

    def generate_row(response, questions)
      answers_hash = response.answers.map { |answer| [answer.question_id, answer] }.to_h
      values = questions.map do |question|
        answer = answers_hash[question.id]
        generate_value(answer)
      end
      [
        response.submitted_at,
        response.course_user.id,
        response.course_user.name,
        response.course_user.role,
        *values
      ]
    end

    def generate_value(answer)
      # Handles the case where there is no answer.
      # This happens when a question is added after the user has submitted a response.
      return '' if answer.nil?

      question = answer.question
      if question.text?
        return answer.text_response || ''
      elsif question.multiple_choice? || question.multiple_response?
        options = answer.options.
                  sort_by { |option| option.question_option.weight }.
                  map { |option| option.question_option.option }
        return options.join(';')
      else
        throw new Exception
      end
    end
  end
end
