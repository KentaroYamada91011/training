import AppBar from '@material-ui/core/AppBar';
import Toolbar from '@material-ui/core/Toolbar';
import IconButton from '@material-ui/core/IconButton';
import MenuIcon from '@material-ui/icons/Menu';
import Typography from '@material-ui/core/Typography';
import DeleteOutlinedIcon from '@material-ui/icons/DeleteOutlined';
import Container from '@material-ui/core/Container';
import TextField from '@material-ui/core/TextField';
import React, { useState, useEffect } from 'react';
import Alert from '@material-ui/lab/Alert';
import AlertTitle from '@material-ui/lab/AlertTitle';
import EventNoteIcon from '@material-ui/icons/EventNote';
import ImportExportIcon from '@material-ui/icons/ImportExport';
import NativeSelect from '@material-ui/core/NativeSelect';
import Layout from '../components/layout';
import FetchClient from '../api/fetchClient';

const Home = (data) => {
  const [taskDetail, setTaskDetail] = useState({});
  const [newTask, setNewTask] = useState('');
  const [tasks, setTasks] = useState([]);
  const [errorMessage, setErrorMessage] = useState('');
  const [isSortedByTime, setIsSortedByTime] = useState(false);
  const basePath = '/api/tasks';

  // const { status, title } = router.query;
  // 初回表示、taskDetail変更ごとにsss全てのタスク取得
  useEffect(() => {
    const fetchData = async () => {
      const getParams = (data.status !== undefined) ? { params: { task: data } } : {};
      const allTasks = await FetchClient.get(basePath, getParams);
      if (isSortedByTime) {
        allTasks.sort((a, b) => (a.deadline < b.deadline ? -1 : 1));
      }
      setTasks(allTasks);
    };
    fetchData();
  }, [taskDetail, isSortedByTime]);

  const getTaskDetail = (task) => {
    task.deadline = task.deadline.slice(0, task.deadline.slice(0, task.deadline.indexOf('.')).lastIndexOf(':'));
    setTaskDetail(task);
  };

  const deleteTask = async (e, task) => {
    e.stopPropagation();
    await FetchClient.delete(`${basePath}/${task.id}`);
    setTaskDetail({ title: '', description: '', deadline: '' });
  };

  const postTask = async (e) => {
    e.preventDefault();
    const res = await FetchClient.post(basePath, { task: { title: newTask } });
    if (res !== undefined && res.status !== 'ERROR') {
      const allTasks = await FetchClient.get(basePath);
      setTasks(allTasks);
      setErrorMessage('');
      setNewTask('');
    } else {
      setErrorMessage(res.message);
    }
  };

  const handleNewTaskChange = (e) => {
    setNewTask(e.target.value);
  };
  // 選択されているタスクが修正されるたびにAPIを回し、task テーブルを修正
  const handleTaskDetailChange = async (e) => {
    const newState = { ...taskDetail };
    newState[e.target.name] = e.target.value;
    if (e.nativeEvent.isComposing !== true) {
      const res = await FetchClient.put(`/api/tasks/${taskDetail.id}`, { task: newState });
      if (res !== null && res !== undefined && res.status !== 'ERROR') {
        setErrorMessage('');
      } else {
        setErrorMessage(res.message);
      }
    }
    setTaskDetail(newState);
  };

  return (
    <Layout>
      <AppBar color="transparent">
        <Toolbar>
          <IconButton
            edge="start"
            color="transparent"
            aria-label="open drawer"
          >
            <MenuIcon />
          </IconButton>
          <Typography component="h1" variant="h6" color="inherit" noWrap>
            TO DO リスト
          </Typography>
          {/* <SearchIcon/> */}
          <form noValidate autoComplete="off">
            <NativeSelect
              defaultValue={data.status !== undefined ? data.status : '全て'}
              name="status"
            >
              <option value="全て">全て</option>
              <option value="未着手">未着手</option>
              <option value="進行中">進行中</option>
              <option value="終了">終了</option>
            </NativeSelect>
            <input
              name="title"
              id="header-title"
              defaultValue={data.title}
              label="検索"
              margin="normal"
              variant="outlined"
              size="small"
            />
            <input id="search" type="submit" value="検索" />
          </form>
        </Toolbar>
      </AppBar>
      <Container>
        <div className="home__main">
          <div className="home__main__list">
            <form noValidate autoComplete="off" onSubmit={(e) => postTask(e)}>
              <TextField name="post-title" id="post-title" fullWidth="true" label="タスクを記入して追加してください" variant="filled" value={newTask} onChange={(e) => handleNewTaskChange(e)} />
            </form>
            <h3>
              taskの一覧
              <span onClick={() => setIsSortedByTime(!isSortedByTime)} className="home__sort__button">
                <ImportExportIcon color={isSortedByTime ? 'primary' : 'disabled'} fontSize="small" />
                <EventNoteIcon color={isSortedByTime ? 'primary' : 'disabled'} fontSize="small" />
              </span>
            </h3>
            <div>
              {tasks != null && tasks.status !== 'ERROR' ? tasks.map((task) => (
                <div className={task.id == taskDetail.id ? 'home__main__item home__main__item--selected' : 'home__main__item'} onClick={() => getTaskDetail(task)}>
                  <p className="home__main__title">
                    {task.id}
                    .
                    {task.title}
                  </p>
                  <DeleteOutlinedIcon className="delete-task" onClick={(e) => deleteTask(e, task)} />
                </div>
              ))
                : null}
            </div>
          </div>
          <div className={'home__main__list' + ' ' + 'home__main__list--right'}>
            <h2>
              task詳細
            </h2>
            {taskDetail.deadline !== undefined
              ? (
                <>
                  <TextField
                    id="datetime-local"
                    label="締め切り"
                    type="datetime-local"
                    name="deadline"
                    className="deadline"
                    defaultValue={taskDetail.deadline}
                    value={taskDetail.deadline === '9999-12-31T23:59' ? '' : taskDetail.deadline}
                    onChange={(e) => handleTaskDetailChange(e)}
                    InputLabelProps={{
                      shrink: true,
                    }}
                  />
                  <div>
                    <NativeSelect
                      name="status"
                      value={taskDetail.status}
                      onChange={(e) => handleTaskDetailChange(e)}
                    >
                      <option value="未着手">未着手</option>
                      <option value="進行中">進行中</option>
                      <option value="終了">終了</option>
                    </NativeSelect>
                  </div>
                </>
              )
              : null}
            <div>
              <h2>
                <input name="title" id="home-title" className="home__description__title" type="text" value={taskDetail.title} onChange={(e) => handleTaskDetailChange(e)} onKeyUp={(e) => handleTaskDetailChange(e)} />
              </h2>
              <p>
                <textarea name="description" id="home-description" className="home__description__description" type="text" value={taskDetail.description} onChange={(e) => handleTaskDetailChange(e)} onKeyUp={(e) => handleTaskDetailChange(e)} />
              </p>
            </div>
          </div>
        </div>
      </Container>
      {errorMessage !== ''
        ? (
          <Alert severity="error" className="home__error">
            <AlertTitle>エラー</AlertTitle>
            <strong>{errorMessage}</strong>
          </Alert>
        )
        : null}
    </Layout>
  );
};
export function getServerSideProps({ query }) {
  if (query.status !== undefined) {
    const data = { status: query.status, title: query.title };
    return {
      props: data,
    };
  }
  return {
    props: {},
  };
}
export default Home;
