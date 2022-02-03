import React from 'react';
import { useSelector } from 'react-redux';
import { RootState } from './modules';
import PrivateRoute from './routes/Private';
import PublicRoute from './routes/Public';
import ModalWrapper from './components/Common/ModalWrapper';
import { TOKEN } from './constant';
import Note from './pages/Note';
import TestRoute from './routes/Test';

function App() {
  const accessToken = localStorage.getItem(TOKEN.ACCESS);
  const modalActive = useSelector((state: RootState) => state.modal.active);

  return (
    <>
      <TestRoute></TestRoute>
      {/* {!accessToken ? <PublicRoute /> : <PrivateRoute />}
      {modalActive && <ModalWrapper active={modalActive} />} */}
    </>
  );
}

export default App;
