import React from 'react';
import { Routes, Route, Navigate, Outlet } from 'react-router-dom';
import Main from '../pages/Main';
import Welcome from '../pages/Welcome';
import WsCreator from '../pages/CreateWs';

export default function PrivateRoute() {
  return (
    <Routes>
      <Route path="/" element={<Welcome></Welcome>}></Route>
      <Route path="/create-workspace" element={<WsCreator />}></Route>

      <Route path="/:wsId" element={<Outlet></Outlet>}>
        <Route path="" element={<Main></Main>}></Route>
        <Route path=":channelId" element={<Main></Main>}>
          <Route path=":noteId" element={<Main></Main>}></Route>
        </Route>
      </Route>

      <Route path="/*" element={<Navigate to={'/'}></Navigate>}></Route>
    </Routes>
  );
}
