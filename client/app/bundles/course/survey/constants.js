import mirrorCreator from 'mirror-creator';

export const questionTypes = {
  TEXT: 'text',
  MULTIPLE_CHOICE: 'multiple_choice',
  MULTIPLE_RESPONSE: 'multiple_response',
};

export const formNames = mirrorCreator([
  'SURVEY',
  'SURVEY_QUESTION',
  'SURVEY_RESPONSE',
  'SURVEY_SECTION',
]);

const actionTypes = mirrorCreator([
  'CREATE_SURVEY_REQUEST',
  'CREATE_SURVEY_SUCCESS',
  'CREATE_SURVEY_FAILURE',
  'LOAD_SURVEY_REQUEST',
  'LOAD_SURVEY_SUCCESS',
  'LOAD_SURVEY_FAILURE',
  'LOAD_SURVEYS_REQUEST',
  'LOAD_SURVEYS_SUCCESS',
  'LOAD_SURVEYS_FAILURE',
  'UPDATE_SURVEY_REQUEST',
  'UPDATE_SURVEY_SUCCESS',
  'UPDATE_SURVEY_FAILURE',
  'DELETE_SURVEY_REQUEST',
  'DELETE_SURVEY_SUCCESS',
  'DELETE_SURVEY_FAILURE',
  'CREATE_SURVEY_QUESTION_REQUEST',
  'CREATE_SURVEY_QUESTION_SUCCESS',
  'CREATE_SURVEY_QUESTION_FAILURE',
  'UPDATE_SURVEY_QUESTION_REQUEST',
  'UPDATE_SURVEY_QUESTION_SUCCESS',
  'UPDATE_SURVEY_QUESTION_FAILURE',
  'DELETE_SURVEY_QUESTION_REQUEST',
  'DELETE_SURVEY_QUESTION_SUCCESS',
  'DELETE_SURVEY_QUESTION_FAILURE',
  'CREATE_SURVEY_SECTION_REQUEST',
  'CREATE_SURVEY_SECTION_SUCCESS',
  'CREATE_SURVEY_SECTION_FAILURE',
  'UPDATE_SURVEY_SECTION_REQUEST',
  'UPDATE_SURVEY_SECTION_SUCCESS',
  'UPDATE_SURVEY_SECTION_FAILURE',
  'DELETE_SURVEY_SECTION_REQUEST',
  'DELETE_SURVEY_SECTION_SUCCESS',
  'DELETE_SURVEY_SECTION_FAILURE',
  'CREATE_RESPONSE_REQUEST',
  'CREATE_RESPONSE_SUCCESS',
  'CREATE_RESPONSE_FAILURE',
  'LOAD_RESPONSE_REQUEST',
  'LOAD_RESPONSE_SUCCESS',
  'LOAD_RESPONSE_FAILURE',
  'UPDATE_RESPONSE_REQUEST',
  'UPDATE_RESPONSE_SUCCESS',
  'UPDATE_RESPONSE_FAILURE',
  'LOAD_SURVEY_RESULTS_REQUEST',
  'LOAD_SURVEY_RESULTS_SUCCESS',
  'LOAD_SURVEY_RESULTS_FAILURE',
  'SURVEY_FORM_SHOW',
  'SURVEY_FORM_HIDE',
  'QUESTION_FORM_SHOW',
  'QUESTION_FORM_HIDE',
  'SECTION_FORM_SHOW',
  'SECTION_FORM_HIDE',
  'SHOW_DELETE_CONFIRMATION',
  'RESET_DELETE_CONFIRMATION',
  'SET_SURVEY_NOTIFICATION',
]);

export default actionTypes;
