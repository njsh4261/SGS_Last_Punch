import React, { useEffect } from 'react';
import { useSelector } from 'react-redux';
import { RootState } from './modules';
import { Route, Routes, useNavigate } from 'react-router-dom';
import PrivateRoute from './routes/Private';
import PublicRoute from './routes/Public';

function App() {
  const modalActive = useSelector((state: RootState) => state.modal.active);
  const jwt = sessionStorage.getItem('jwt');
  const navigate = useNavigate();

  // jwt가 없으면 login page로 redirect
  useEffect(() => {
    if (!jwt) navigate('/login');
    else navigate('/', { state: { jwt } });
  }, []);

  return (
    <>
      {!jwt ? <PublicRoute /> : <PrivateRoute />}
      {modalActive && <div>modal open</div>}
    </>
  );
}

export default App;
