# frozen_string_literal: true
require 'rails_helper'
require 'csv'

RSpec.describe Course::Survey::SurveyExportService do
  let(:instance) { Instance.default }
  with_tenant(:instance) do
    let(:course) { create(:course) }
    let(:survey) do
      create(:survey, course: course)
    end
    let(:student) { create(:course_student, course: course) }
    let(:section) { create(:course_survey_section, survey: survey) }
    let(:survey_traits) { nil }
    let(:response) do
      create(:response,
             survey: survey, creator: student.user, course_user: student, submitted_at: Time.now)
    end

    describe '#export' do
      let!(:option_one) { create(:course_survey_question_option, question: question, option: 'O1') }
      let!(:option_two) { create(:course_survey_question_option, question: question, option: 'O2') }
      let!(:option_three) { create(:course_survey_question_option, question: question, option: 'O3') }
      let!(:answer) { create(:course_survey_answer, response: response, question: question) }

      context 'MRQ question' do
        let!(:question) { create(:course_survey_question, question_type: :multiple_response, section: section) }

        context 'when all options are selected' do
          before do
            answer_option_one = Course::Survey::AnswerOption.create(answer: answer, question_option: option_one)
            answer_option_two  = Course::Survey::AnswerOption.create(answer: answer, question_option: option_two)
            answer_option_three = Course::Survey::AnswerOption.create(answer: answer, question_option: option_three)
          end

          it 'selected options are delimitted by semicolons' do
            csv = Course::Survey::SurveyExportService.export(survey)
            csv_arr = CSV.parse(csv)
            expect(csv_arr[1][1]).to eq('O1;O2;O3')
          end
        end

        context 'when no options are selected' do
          it 'selected options are delimitted by semicolons' do
            csv = Course::Survey::SurveyExportService.export(survey)
            csv_arr = CSV.parse(csv)
            expect(csv_arr[1][1]).to eq('')
          end
        end
      end

      context 'MCQ question' do
        let!(:question) { create(:course_survey_question, question_type: :multiple_choice, section: section) }

        context 'when an option is selected' do
          before do
            answer_option_one = Course::Survey::AnswerOption.create(answer: answer, question_option: option_one)
          end

          it 'selected options are delimitted by semicolons' do
            csv = Course::Survey::SurveyExportService.export(survey)
            csv_arr = CSV.parse(csv)
            expect(csv_arr[1][1]).to eq('O1')
          end
        end

        context 'when no options are selected' do
          it 'selected options are delimitted by semicolons' do
            csv = Course::Survey::SurveyExportService.export(survey)
            csv_arr = CSV.parse(csv)
            expect(csv_arr[1][1]).to eq('')
          end
        end
      end

      context 'text response question' do
        let!(:question) { create(:course_survey_question, question_type: :text, section: section) }

        context 'when there is text' do
          let!(:answer) { create(:course_survey_answer, response: response, question: question, text_response: 'TEXT') }

          it 'the text is included as a value' do
            csv = Course::Survey::SurveyExportService.export(survey)
            csv_arr = CSV.parse(csv)
            expect(csv_arr[1][1]).to eq('TEXT')
          end
        end

        context 'when there is no text' do
          let!(:answer) { create(:course_survey_answer, response: response, question: question, text_response: nil) }

          it 'empty string is included as a value' do
            csv = Course::Survey::SurveyExportService.export(survey)
            csv_arr = CSV.parse(csv)
            expect(csv_arr[1][1]).to eq('')
          end
        end
      end
    end

    describe '#generate_row' do
      describe 'values are generated in the same order as questions'
      end

      describe 'same no. of values as questions'
      end
    end

    describe '#generate_value' do
      context 'MRQ question' do
        context 'all options are selected' do
        end

        context 'no options are selected' do
        end
      end

      context 'MCQ question' do
        context 'one option is selected' do
        end

        context 'no options are selected' do
        end
      end

      context 'Text response question' do
        context 'when there is text' do
        end

        context 'when there is no text' do
        end
      end
    end
  end
end
