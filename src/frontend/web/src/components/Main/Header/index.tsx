import React from 'react';
import styled from 'styled-components';
import MainHeaderFrame from '../../Common/MainHeaderFrame';

const Hside = styled.article`
  flex: 1;
  display: flex;
  justify-content: flex-end;
  align-items: center;
  padding-left: 16px;
  padding-right: 20px;
`;

const Hright = styled.article`
  flex: 1;
  display: flex;
  justify-content: flex-end;
  color: white;
  padding-right: 10px;
`;

export default function MainHeader({ wsName }: { wsName: string }) {
  return (
    <MainHeaderFrame>
      <Hside></Hside>
      <Hright>
        <button>profile</button>
      </Hright>
    </MainHeaderFrame>
  );
}
