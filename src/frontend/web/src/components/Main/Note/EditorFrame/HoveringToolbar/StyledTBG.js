import { withStyles } from '@material-ui/core/styles';
import { ToggleButtonGroup } from '@material-ui/lab';

const StyledToggleButtonGroup = withStyles((theme) => ({
  grouped: {
    // margin: theme.spacing(0.5),
    border: 'none',
  },
}))(ToggleButtonGroup);

export default StyledToggleButtonGroup;
