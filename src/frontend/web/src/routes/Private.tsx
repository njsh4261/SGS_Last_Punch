import React from 'react';
import { Routes, Route } from 'react-router-dom';
import Chat from '../components/Main/Chat';
import Welcome from '../pages/Welcome';
import WsCreator from '../pages/WsCreator';

export default function PrivateRoute() {
  return (
    <Routes>
      <Route path="/" element={<Welcome></Welcome>}></Route>
      <Route path="/create-workspace" element={<WsCreator />}></Route>
      <Route path="/chat" element={<Chat />}></Route>
      <Route path="/*" element={<Welcome></Welcome>}></Route>
    </Routes>
  );
}
