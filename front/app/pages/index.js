import Layout, { siteTitle } from '../components/layout'
import AppBar from '@material-ui/core/AppBar';
import Toolbar from '@material-ui/core/Toolbar';
import IconButton from '@material-ui/core/IconButton';
import MenuIcon from '@material-ui/icons/Menu';
import Typography from '@material-ui/core/Typography';
import Badge from '@material-ui/core/Badge';
import NotificationsIcon from '@material-ui/icons/Notifications';
import Container from '@material-ui/core/Container';
import TextField from '@material-ui/core/TextField';
import React, { useState, useEffect } from 'react';
import FetchClient from '../components/api/fetchClient'

const Home = (props) => {
  const [taskDetail, setTaskDetail] = useState({});
  const [newTask, setNewTask] = useState("");
  const [tasks, setTasks] = useState([]);

  useEffect(() => {
    setTasks(props.tasks)
  }, []);

  const getTaskDetail = (task) => {
    setTaskDetail(task)
  }

  const postTask = async (e) => {
    e.preventDefault();
    const res = await FetchClient.post("/api/tasks", {task:{title: newTask}})
    if (res !== undefined || res.status !== "error") {
      const allTaks = await FetchClient.get("/api/tasks")
      setTasks(allTaks)
      setNewTask("")
    }
  }

  const handleNewTaskChange = (e) => {
    setNewTask(e.target.value)
  }

  return (
    <Layout>
      <AppBar　color="transparent">
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
              <TextField fullWidth="true" label="タスクを記入して追加してください" variant="filled" value={newTask} onChange={(e) => handleNewTaskChange(e)}  />
            </form>
            <h3>
                taskの一覧
            </h3>
            <div>
              {tasks.map((task) =>
                <div onClick={() => getTaskDetail(task)}>
                  {task.id}.{task.title}
                </div>
              )}
            </div>
          </div>
          <div className={'home__main__list' + ' ' + `home__main__list--right`}>
            <h2>
                task詳細
              </h2>
              <table>
                <div onClick={() => getTaskDetail(task)}>
                    <h2>
                      {taskDetail.title}
                    </h2>
                    <p>
                    {taskDetail.description}
                    </p>
                  </div>
              </table>
          </div>
        </div>
      </Container>
    </Layout>
  )
}

export const getStaticProps = async () => {
  // URLはlocalhostではなくapiとなる
  const response = await fetch("http://api:3000/api/tasks", {method: "GET"});
  const json = await response.json();

  return {
    props: {
      tasks: json
    },
  };
}

export default Home;