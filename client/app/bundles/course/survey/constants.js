import mirrorCreator from 'mirror-creator';

export const questionTypes = {
  TEXT: '0',
  MULTIPLE_CHOICE: '1',
  MULTIPLE_RESPONSE: '2',
};

export const formNames = mirrorCreator([
  'SURVEY',
  'SURVEY_QUESTION',
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
  'SURVEY_FORM_SHOW',
  'SURVEY_FORM_HIDE',
  'QUESTION_FORM_SHOW',
  'QUESTION_FORM_HIDE',
  'SHOW_DELETE_CONFIRMATION',
  'RESET_DELETE_CONFIRMATION',
  'SET_SURVEY_NOTIFICATION',
  'RESET_SURVEY_NOTIFICATION',
]);

export default actionTypes;