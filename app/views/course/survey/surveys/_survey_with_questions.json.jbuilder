# frozen_string_literal: true
json.partial! 'course/survey/surveys/survey', survey: survey
json.sections @sections, partial: 'course/survey/sections/section', as: :section
