import React from 'react';
import { useSelector } from 'react-redux';
import { RootState } from './modules';
import PrivateRoute from './routes/Private';
import PublicRoute from './routes/Public';
import ModalWrapper from './components/Common/ModalWrapper';

function App() {
  const jwt = sessionStorage.getItem('jwt');
  const modalActive = useSelector((state: RootState) => state.modal.active);

  return (
    <>
      {!jwt ? <PublicRoute /> : <PrivateRoute />}
      {modalActive && <ModalWrapper active={modalActive} />}
    </>
  );
}

export default App;
