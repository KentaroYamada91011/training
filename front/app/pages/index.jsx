import AppBar from '@material-ui/core/AppBar';
import Toolbar from '@material-ui/core/Toolbar';
import IconButton from '@material-ui/core/IconButton';
import MenuIcon from '@material-ui/icons/Menu';
import Typography from '@material-ui/core/Typography';
import Badge from '@material-ui/core/Badge';
import NotificationsIcon from '@material-ui/icons/Notifications';
import DeleteOutlinedIcon from '@material-ui/icons/DeleteOutlined';
import Container from '@material-ui/core/Container';
import TextField from '@material-ui/core/TextField';
import React, { useState, useEffect } from 'react';
import Alert from '@material-ui/lab/Alert';
import AlertTitle from '@material-ui/lab/AlertTitle';
import Layout from '../components/layout';
import FetchClient from '../api/fetchClient';

const Home = () => {
  const [taskDetail, setTaskDetail] = useState({});
  const [newTask, setNewTask] = useState('');
  const [tasks, setTasks] = useState([]);
  const [errorMessage, setErrorMessage] = useState('');
  const basePath = '/api/tasks';
  // 初回表示、taskDetail変更ごとに全てのタスク取得
  useEffect(() => {
    const fetchData = async () => {
      const allTasks = await FetchClient.get(basePath);
      setTasks(allTasks);
    };
    fetchData();
  }, [taskDetail]);

  const getTaskDetail = (task) => {
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
      if (res !== null && res.status !== 'ERROR') {
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
          <IconButton color="inherit">
            <Badge badgeContent={4} color="secondary">
              <NotificationsIcon />
            </Badge>
          </IconButton>
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
            </h3>
            <div>
              {tasks != null && tasks.status !== 'ERROR' ? tasks.map((task) => (
                <div className={task.id == taskDetail.id ? 'home__main__item home__main__item--selected' : 'home__main__item'} onClick={() => getTaskDetail(task)}>
                  <p>
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
            <div>
              <h2>
                <input name="title" className="home__description__title" type="text" value={taskDetail.title} onChange={(e) => handleTaskDetailChange(e)} onKeyUp={(e) => handleTaskDetailChange(e)} />
              </h2>
              <p>
                <textarea name="description" className="home__description__description" type="text" value={taskDetail.description} onChange={(e) => handleTaskDetailChange(e)} onKeyUp={(e) => handleTaskDetailChange(e)} />
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

export default Home;
