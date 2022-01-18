import React from 'react';
import { useSelector } from 'react-redux';
import { RootState } from '../../../modules';
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
  const wsName = useSelector((state: RootState) => state.work.name);
  return (
    <MainHeaderFrame>
      <Hside>
        <HhistoryIcon></HhistoryIcon>
      </Hside>
      <SearchContainer workspaceName={wsName}></SearchContainer>
      <Hright>memeber</Hright>
    </MainHeaderFrame>
  );
}
