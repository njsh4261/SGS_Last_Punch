import React from 'react';
import { useSelector } from 'react-redux';
import { RootState } from './modules';
import PrivateRoute from './routes/Private';
import PublicRoute from './routes/Public';
import ModalWrapper from './components/Common/ModalWrapper';
import { TOKEN } from './constant';

function App() {
  const accessToken = localStorage.getItem(TOKEN.ACCESS);
  const modalActive = useSelector((state: RootState) => state.modal.active);

  return (
    <>
      {!accessToken ? <PublicRoute /> : <PrivateRoute />}
      {modalActive && <ModalWrapper active={modalActive} />}
    </>
  );
}

export default App;
