import React, { PropTypes } from 'react';
import DatePicker from 'material-ui/DatePicker';
import TimePicker from 'material-ui/TimePicker';
import Toggle from 'material-ui/Toggle';
import LessonPlanFilter from '../containers/LessonPlanFilter';
import DeleteIcon from 'material-ui/svg-icons/navigation/cancel';
import { constants } from '../constants';

const propTypes = {
  milestoneGroups: PropTypes.array,
  updateItemDateTime: PropTypes.func,
  updateMilestoneDateTime: PropTypes.func,
  updateItemField: PropTypes.func,
};

const styles = {
  datePickerTextField: {
    width: 75,
    fontSize: 14,
  },
  timePickerTextField: {
    width: 65,
    fontSize: 14,
  },
  filter: {
    bottom: 12,
    position: 'fixed',
    right: 24,
  },
  deleteIcon: {
    cursor: 'pointer',
    margin: '0px 0px 0px -8px',
  },
};

class LessonPlanEdit extends React.Component {
  static renderDateCell(fieldName, originalDate, onChangeHandler) {
    return(
      <td>
        <DatePicker
          name={fieldName}
          value={originalDate}
          textFieldStyle={styles.datePickerTextField}
          onChange={onChangeHandler}
        />
      </td>
    );
  }

  static renderTimeCell(fieldName, originalTime, onChangeHandler) {
    return(
      <td>
        <TimePicker
          name={fieldName}
          value={originalTime}
          textFieldStyle={styles.timePickerTextField}
          onChange={onChangeHandler}
        />
      </td>
    );
  }

  renderMilestone(milestone) {
    const { updateMilestoneDateTime } = this.props;
    const startAt = new Date(milestone.get('start_at'));
    const milestoneId = milestone.get('id');

    if (milestone.get('id') === constants.PRIOR_ITEMS_MILESTONE) {
      return [];
    }

    return (
      <tr>
        <td />
        <td>
          <h3>
            { milestone.get('title') }
          </h3>
        </td>
        {
          LessonPlanEdit.renderDateCell('start_at', startAt,
            (event, newDate) => updateMilestoneDateTime(milestoneId, newDate, startAt, startAt))
        }
        {
          LessonPlanEdit.renderTimeCell('start_at', startAt,
            (event, newTime) => updateMilestoneDateTime(milestoneId, startAt, newTime, startAt))
        }
        <td />
        <td />
        <td />
        <td />
        <td />
      </tr>
    );
  }

  renderItem(item) {
    const { updateItemDateTime, updateItemField } = this.props;
    const startAt = new Date(item.get('start_at'));
    const bonusEndAt = item.get('bonus_end_at') ? new Date(item.get('bonus_end_at')) : undefined;
    const endAt = item.get('end_at') ? new Date(item.get('end_at')) : undefined;
    const itemId = item.get('id');

    return (
      <tr key={itemId}>
        <td>{ item.get('lesson_plan_item_type').join(': ') }</td>
        <td>
          <TextField
            value={ item.get('title') }
            hintText="Title"
            required
          />
        </td>
        {
          LessonPlanEdit.renderDateCell('start_at', startAt,
            (event, newDate) => updateItemDateTime(itemId, 'start_at', newDate, startAt, startAt))
        }
        {
          LessonPlanEdit.renderTimeCell('start_at', startAt,
            (event, newTime) => updateItemDateTime(itemId, 'start_at', startAt, newTime, startAt))
        }
        {
          LessonPlanEdit.renderDateCell('bonus_end_at', bonusEndAt,
            (event, newDate) => updateItemDateTime(itemId, 'bonus_end_at', newDate, bonusEndAt, bonusEndAt))
        }
        {
          LessonPlanEdit.renderTimeCell('bonus_end_at', bonusEndAt,
            (event, newTime) => updateItemDateTime(itemId, 'bonus_end_at', bonusEndAt, newTime, bonusEndAt))
        }
        <td>
          {
            bonusEndAt ?
              <DeleteIcon
                style={styles.deleteIcon}
                onTouchTap={() => updateItemField(itemId, 'bonus_end_at', null)}
              /> :
              []
          }
        </td>
        {
          LessonPlanEdit.renderDateCell('end_at', endAt,
            (event, newDate) => updateItemDateTime(itemId, 'end_at', newDate, endAt))
        }
        {
          LessonPlanEdit.renderTimeCell('end_at', endAt,
            (event, newTime) => updateItemDateTime(itemId, 'end_at', endAt, newTime))
        }
        <td>
          {
            endAt ?
              <DeleteIcon
                style={styles.deleteIcon}
                onTouchTap={() => updateItemField(itemId, 'end_at', null)}
              /> :
              []
          }
        </td>
        <td>
          <Toggle
            toggled={item.get('published')}
            onToggle={(event, isToggled) => updateItemField(itemId, 'published', isToggled)}
          />
        </td>
      </tr>
    );
  }

  renderGroup(group) {
    return group.items.map(item => this.renderItem(item))
           .unshift(this.renderMilestone(group.milestone));
  }

  render() {
    const { milestoneGroups } = this.props;
    return (
      <div>
        <table>
          <tbody>
            {
               milestoneGroups.map(group => this.renderGroup(group))
            }
          </tbody>
        </table>
        <div style={styles.filter}>
          <LessonPlanFilter />
        </div>
      </div>
    );
  }
}

LessonPlanEdit.propTypes = propTypes;

export default LessonPlanEdit;
