import React from 'react';
import { useSelector } from 'react-redux';
import { RootState } from './modules';
import { Route, Routes } from 'react-router-dom';
import Chat from './components/Chat';
import MainHeader from './components/MianHeader';
import LoginPage from './pages/Login';

function App() {
  const jwt = sessionStorage.getItem('jwt');
  const modalActive = useSelector((state: RootState) => state.modal.active);

  return (
    <>
      <Routes>
        <Route path="login" element={<LoginPage />}></Route>
        <Route path="/header" element={<MainHeader />}></Route>
        <Route path="/chat" element={<Chat />}></Route>
        <Route path="/*" element={<div>not found</div>}></Route>
      </Routes>
      {modalActive && <div>modal open</div>}
    </>
  );
}

export default App;
