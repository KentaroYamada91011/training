import Alert from '@material-ui/lab/Alert';
import AlertTitle from '@material-ui/lab/AlertTitle';

const Custom404 = () => (
  <Alert severity="error">
    <AlertTitle>404</AlertTitle>
    Page Not Found —
    {' '}
    <strong>ページが見つかりません</strong>
  </Alert>
);
export default Custom404;
