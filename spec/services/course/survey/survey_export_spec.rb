# frozen_string_literal: true
require 'rails_helper'
require 'csv'

RSpec.describe Course::Survey::SurveyExportService do
  let(:instance) { Instance.default }
  with_tenant(:instance) do
    let(:course) { create(:course) }
    let(:student) { create(:course_student, course: course).user }
    let!(:survey) do
      create(:survey, course: course, published: true, end_at: Time.zone.now + 1.day,
                      creator: course.creator, updater: course.creator)
    end
    let(:response) do
      create(:course_survey_response, survey: survey, creator: student,
                                      submitted_at: Time.zone.now)
    end

    describe '#generate_row' do
      subject do
        Course::Survey::SurveyExportService.send(:generate_row, response, questions)
      end

      let(:questions) do
        section = create(:course_survey_section, survey: survey)
        [
          create(:course_survey_question, question_type: :text, section: section),
          create(:course_survey_question, question_type: :text, section: section),
          create(:course_survey_question, question_type: :text, section: section)
        ]
      end

      let!(:answers) do
        [
          create(:course_survey_answer, question: questions[0], response: response, text_response: 'Q1 Answer'),
          create(:course_survey_answer, question: questions[1], response: response, text_response: 'Q2 Answer'),
          create(:course_survey_answer, question: questions[2], response: response, text_response: 'Q3 Answer')
        ]
      end

      it 'returns an array with same length as no. of questions' do
        expect(subject.size).to eq(questions.size)
      end

      it 'returns answers that correspond to questions' do
        expect(subject).to eq(['Q1 Answer', 'Q2 Answer', 'Q3 Answer'])
      end
    end

    describe '#generate_value' do
      subject do
        Course::Survey::SurveyExportService.send(:generate_value, answer)
      end

      context 'MRQ question' do
        let(:question) do
          section = create(:course_survey_section, survey: survey)
          create(:course_survey_question, question_type: :multiple_response, section: section)
        end
        let(:options) do
          [
            create(:course_survey_question_option, question: question, option: 'Cool', weight: 5),
            create(:course_survey_question_option, question: question, option: 'Nice', weight: 2),
            create(:course_survey_question_option, question: question, option: 'Ok', weight: 3)
          ]
        end
        let(:answer) do
          create(:course_survey_answer, question: question, response: response)
        end

        context 'all options are selected' do
          before do
            options.each do |question_option|
              answer.options.build(question_option: question_option)
            end
          end

          it 'joins all options with semicolon in increasing weight' do
            expect(subject).to eq('Nice;Ok;Cool')
          end
        end

        context 'no options are selected' do
          before do
            answer.options.destroy_all
          end

          it 'returns an empty string' do
            expect(subject).to eq('')
          end
        end
      end

      context 'MCQ question' do
        let(:question) do
          section = create(:course_survey_section, survey: survey)
          create(:course_survey_question, question_type: :multiple_choice, section: section)
        end
        let(:options) do
          [
            create(:course_survey_question_option, question: question, option: 'Cool', weight: 5),
            create(:course_survey_question_option, question: question, option: 'Nice', weight: 2),
            create(:course_survey_question_option, question: question, option: 'Ok', weight: 3)
          ]
        end
        let(:answer) do
          create(:course_survey_answer, question: question, response: response)
        end

        context 'one option is selected' do
          before do
            answer.options.build(question_option: options[0])
          end

          it 'returns the selected option' do
            expect(subject).to eq('Cool')
          end
        end

        context 'no options are selected' do
          before do
            answer.options.destroy_all
          end

          it 'returns an empty string' do
            expect(subject).to eq('')
          end
        end
      end

      context 'Text response question' do
        let(:question) do
          section = create(:course_survey_section, survey: survey)
          create(:course_survey_question, question_type: :text, section: section)
        end

        context 'when there is text' do
          let(:answer) do
            create(:course_survey_answer, question: question, response: response, text_response: 'Fortnite')
          end

          it 'returns the text' do
            expect(subject).to eq('Fortnite')
          end
        end

        context 'when there is no text' do
          let(:answer) do
            create(:course_survey_answer, question: question, response: response, text_response: nil)
          end

          it 'returns an empty string' do
            expect(subject).to eq('')
          end
        end
      end
    end
  end
end
