# frozen_string_literal: true
require 'csv'

class Course::Survey::SurveyExportService

  def export(survey)
    responses = Course::Survey::Response.includes(answers: [:options, :question]).where(survey: survey)
    questions = survey.questions
    header = generate_header(questions)

    CSV.generate(headers: true, force_quotes: true) do |csv|
      csv << header
      responses.each do |response|
        row = []
        row.push(response.submitted_at)
        row.push(*generate_row(response, questions))
        csv << row
      end
    end
  end

  private

  def generate_header(questions)
    ["Timestamp"] + questions.map {|question| question.description }
  end

  def generate_row(response, questions)
    answers_hash = response.answers.map { |answer| [answer.question_id, answer] }.to_h
    questions.map do |question|
      answer = answers_hash[question.id]
      generate_value(answer)
    end
  end

  def generate_value(answer)
    question = answer.question
    if question.text?
      return answer.text_response
    elsif question.multiple_choice? || question.multiple_response?
      options = answer.options.map { |option| option.question_option.option }
      return options.join(";")
    else
      throw new Exception
    end
  end
end
