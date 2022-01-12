import React from 'react';
import styled from 'styled-components';
import MainHeaderFrame from '../../Common/MainHeaderFrame';
import SearchContainer from './Search';
import icon from '../../../icon/restore.svg';

const Hside = styled.article`
  flex: 1;
  display: flex;
  justify-content: flex-end;
  align-items: center;
  padding-left: 16px;
  padding-right: 20px;
`;

const HhistoryIcon = styled.article`
  width: 24px;
  height: 24px;
  background-image: url(${icon});
  background-repeat: no-repeat;
`;

const Hright = styled.article`
  flex: 1;
  display: flex;
  justify-content: flex-end;
`;

export default function MainHeader() {
  const dummyWorkspace = 'dummy ws name';
  return (
    <MainHeaderFrame>
      <Hside>
        <HhistoryIcon></HhistoryIcon>
      </Hside>
      <SearchContainer workspaceName={dummyWorkspace}></SearchContainer>
      <Hright>memeber</Hright>
    </MainHeaderFrame>
  );
}
