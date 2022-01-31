import React, { useState, useEffect } from 'react';
import { useSelector } from 'react-redux';
import { RootState } from './modules';
import PrivateRoute from './routes/Private';
import PublicRoute from './routes/Public';
import ModalWrapper from './components/Common/ModalWrapper';
import { TOKEN } from './constant';
import Note from './pages/Note';
import { createNoteAPI, getNoteListAPI } from './Api/note';

function App() {
  const accessToken = sessionStorage.getItem(TOKEN.ACCESS);
  const modalActive = useSelector((state: RootState) => state.modal.active);

  const [noteList, setNoteList] = useState<any[]>([]);
  const testCreateHandler = async () => {
    const noteId = await createNoteAPI(1, 1, 1);
    if (noteId) setNoteList([...noteList, noteId]);
  };
  const testGetListHandler = async () => {
    const responseNoteList = await getNoteListAPI(1);
    if (responseNoteList)
      setNoteList(responseNoteList.map((resNote) => resNote.id));
  };
  useEffect(() => {
    testGetListHandler();
  }, []);

  return (
    <>
      <button onClick={testCreateHandler}>create note</button>
      <div>
        {noteList.map((note) => (
          <div key={note}>{note}</div>
        ))}
      </div>
      <Note></Note>
      {/* {!accessToken ? <PublicRoute /> : <PrivateRoute />}
      {modalActive && <ModalWrapper active={modalActive} />} */}
    </>
  );
}

export default App;
