import React from 'react';
import { Routes, Route } from 'react-router-dom';
import Chat from '../components/Chat';
import MainHeader from '../components/MianHeader';
import Welcome from '../pages/Welcome';

export default function PrivateRoute() {
  return (
    <Routes>
      <Route path="/" element={<Welcome></Welcome>}></Route>
      <Route path="/header" element={<MainHeader />}></Route>
      <Route path="/chat" element={<Chat />}></Route>
      <Route path="/*" element={<Welcome></Welcome>}></Route>
    </Routes>
  );
}
