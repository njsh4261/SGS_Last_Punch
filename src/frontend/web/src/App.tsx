import React from 'react';
import { useSelector } from 'react-redux';
import { RootState } from './modules';
import PrivateRoute from './routes/Private';
import PublicRoute from './routes/Public';

function App() {
  const jwt = sessionStorage.getItem('jwt');
  const modalActive = useSelector((state: RootState) => state.modal.active);

  return (
    <>
      {!jwt ? <PublicRoute /> : <PrivateRoute />}
      {modalActive && <div>modal open</div>}
    </>
  );
}

export default App;
