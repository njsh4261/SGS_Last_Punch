import React from 'react';
import { useSelector } from 'react-redux';
import { RootState } from './modules';
import Chat from './components/Chat';
import MainHeader from './components/MianHeader';

function App() {
  const modalActive = useSelector((state: RootState) => state.modal.active);
  return (
    <>
      <MainHeader></MainHeader>
      {modalActive && <div>modal open</div>}
    </>
  );
  // return <Chat></Chat>;
}

export default App;
