import React, { useEffect } from 'react';
import { useSelector } from 'react-redux';
import { RootState } from './modules';
import { Route, Routes, useNavigate } from 'react-router-dom';
import Chat from './components/Chat';
import MainHeader from './components/MianHeader';
import LoginPage from './pages/Login';
import Signup from './pages/Signup';
import Welcome from './pages/Welcome';

function App() {
  const modalActive = useSelector((state: RootState) => state.modal.active);
  const navigate = useNavigate();

  // jwt가 없으면 login page로 redirect
  useEffect(() => {
    const jwt = sessionStorage.getItem('jwt');
    console.log(jwt);
    if (!jwt) navigate('/login');
    else navigate('/', { state: { jwt } });
  }, []);

  return (
    <>
      <Routes>
        <Route path="/" element={<Welcome></Welcome>}></Route>
        <Route path="/login" element={<LoginPage />}></Route>
        <Route path="/signup" element={<Signup />}></Route>
        <Route path="/header" element={<MainHeader />}></Route>
        <Route path="/chat" element={<Chat />}></Route>
        <Route path="/*" element={<div>not found</div>}></Route>
      </Routes>
      {modalActive && <div>modal open</div>}
    </>
  );
}

export default App;
