import React from 'react';
import { Routes, Route, Navigate, Outlet } from 'react-router-dom';
import Main from '../pages/Main';
import Welcome from '../pages/Welcome';
import WsCreator from '../pages/CreateWs';
import Note from '../pages/Note';
import Task from '../pages/Task';

export default function PrivateRoute() {
  return (
    <Routes>
      <Route path="/" element={<Welcome></Welcome>}></Route>
      <Route path="/create-workspace" element={<WsCreator />}></Route>

      <Route path="/:wsId" element={<Outlet></Outlet>}>
        <Route path="" element={<Main></Main>}></Route>
        <Route path=":channelId" element={<Main></Main>}></Route>
        <Route path=":channelId/note" element={<Note></Note>}></Route>
        <Route path=":channelId/task" element={<Task></Task>}></Route>
      </Route>

      <Route path="/*" element={<Navigate to={'/'}></Navigate>}></Route>
    </Routes>
  );
}
