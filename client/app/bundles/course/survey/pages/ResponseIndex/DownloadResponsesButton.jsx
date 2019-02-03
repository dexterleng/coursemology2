import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { defineMessages, FormattedMessage } from 'react-intl';
import RaisedButton from 'material-ui/RaisedButton';
import { downloadSurvey } from 'course/survey/actions/surveys';

const translations = defineMessages({
  download: {
    id: 'course.surveys.ResponseIndex.DownloadResponse.download',
    defaultMessage: 'Download Responses',
  },
});

class DownloadResponsesButton extends React.Component {
  static propTypes = {
    dispatch: PropTypes.func.isRequired,
  }

  render() {
    return (
      <>
        <RaisedButton
          label={<FormattedMessage {...translations.download} />}
          onClick={() => this.props.dispatch(downloadSurvey())}
        />
      </>
    );
  }
}

export default connect()(DownloadResponsesButton);
