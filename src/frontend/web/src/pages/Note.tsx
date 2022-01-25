import React, { useState } from 'react';
import { useParams, useLocation } from 'react-router-dom';
import styled from 'styled-components';
import NoteSideHeader from '../components/Note/Side/Header';
import NoteSideMenu from '../components/Note/Side/Menu';
import NoteSideList from '../components/Note/Side/List';
import NoteHeader from '../components/Note/Header';
import NoteMain from '../components/Note/Main';

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
  const [sideToggle, setSideToggle] = useState(true);
  const [hover, setHover] = useState(false);
  const params = useParams();

  const toggleHandler = () => setSideToggle((state) => !state);
  const hoverHandler = () => setHover((state) => !state);

  return (
    <Layout>
      <SideFrame sideToggle={sideToggle}>
        <NoteSideHeader
          hover={hover}
          hoverHandler={hoverHandler}
          channelName={params.channelName as string}
          toggleHandler={toggleHandler}
        ></NoteSideHeader>
        <NoteSideMenu></NoteSideMenu>
        <NoteSideList></NoteSideList>
      </SideFrame>
      <Container>
        <HeaderFrame>
          <NoteHeader
            sideToggle={sideToggle}
            toggleHandler={toggleHandler}
          ></NoteHeader>
        </HeaderFrame>
        <MainFrame>
          <NoteMain></NoteMain>
        </MainFrame>
      </Container>
    </Layout>
  );
}
