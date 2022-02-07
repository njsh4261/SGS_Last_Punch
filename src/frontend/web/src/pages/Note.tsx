import React, { useState, useEffect } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import styled from 'styled-components';
import NoteSideHeader from '../components/Note/Side/Header';
import NoteSideMenu from '../components/Note/Side/Menu';
import NoteSideList from '../components/Note/Side/List';
import NoteHeader from '../components/Note/Header';
import NoteMain from '../components/Note/Main';
import { createNoteAPI, getNoteListAPI, getSpecificNoteAPI } from '../Api/note';

const Layout = styled.div`
  display: flex;
  height: 100%;
`;

const SideFrame = styled.aside<{ sideToggle: boolean }>`
  width: ${(props) => (props.sideToggle ? '240px' : '0px')};
  color: #72706c;
  font-size: 14px;
  background-color: #f7f6f3;
  transition: width 300ms;
  overflow: hidden;
  white-space: nowrap;
`;

const Container = styled.div`
  flex: 1;
  display: flex;
  flex-direction: column;
`;

const TestContainer = styled.div`
  margin-top: 50px;
`;

const HeaderFrame = styled.header`
  height: 45px;
  display: flex;
`;

const MainFrame = styled.main`
  flex: 1;
  background-color: white;
  overflow-y: scroll;
`;

export default function Note() {
  // return <>todo: delete this</>;
  const [sideToggle, setSideToggle] = useState(true);
  const [hover, setHover] = useState(false);
  const params = useParams();

  const toggleHandler = () => setSideToggle((state) => !state);
  const hoverHandler = () => setHover((state) => !state);

  // testing
  const navigate = useNavigate();
  const [selectedNote, selectNote] = useState();
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
  const testGetSpecificHandler = async (
    e: React.MouseEvent<HTMLDivElement>,
  ) => {
    // const responseNote = await getSpecificNoteAPI((e.target as any).id);
    // { id, creatorId, title, content(initValue), ops(null | []), createDt, modifyDt}
    // selectNote(responseNote);
    navigate('/' + (e.target as any).id);
  };
  useEffect(() => {
    testGetListHandler();
  }, []);

  return (
    <Layout>
      <SideFrame sideToggle={sideToggle}>
        <NoteSideHeader
          hover={hover}
          hoverHandler={hoverHandler}
          channelName={params.channelName as string}
          toggleHandler={toggleHandler}
        ></NoteSideHeader>
        {/* <NoteSideMenu></NoteSideMenu>
        <NoteSideList></NoteSideList> */}
        <TestContainer>
          <button onClick={testCreateHandler}>create note</button>
          <div>
            {noteList.map((note) => (
              <div id={note} key={note} onClick={testGetSpecificHandler}>
                {note}
              </div>
            ))}
          </div>
        </TestContainer>
      </SideFrame>
      <Container>
        <HeaderFrame>
          <NoteHeader
            sideToggle={sideToggle}
            toggleHandler={toggleHandler}
          ></NoteHeader>
        </HeaderFrame>
        <MainFrame>{/* <NoteMain></NoteMain> */}</MainFrame>
      </Container>
    </Layout>
  );
}
