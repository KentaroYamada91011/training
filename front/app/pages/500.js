import Alert from '@material-ui/lab/Alert';
import AlertTitle from '@material-ui/lab/AlertTitle';

const Custom500 = () => (
  <Alert severity="error">
    <AlertTitle>500</AlertTitle>
    Internal Server Error. —
    {' '}
    <strong>ページが見つかりません</strong>
  </Alert>
);
export default Custom500;
