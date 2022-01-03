import React from 'react';
import styled from 'styled-components';
import icon from '../../icon/restore.svg';

const HeaderContainer = styled.header`
  display: flex;
  justify-content: space-between;
  background-color: beige;
  padding: 6px 0px;
`;

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

const Hsearch = styled.article`
  flex: 2;
`;

const Hright = styled.article`
  flex: 1;
  display: flex;
  justify-content: flex-end;
`;

const Header = () => {
  return (
    <HeaderContainer>
      <Hside>
        <HhistoryIcon></HhistoryIcon>
      </Hside>
      <Hsearch>search</Hsearch>
      <Hright>memeber</Hright>
    </HeaderContainer>
  );
};

export default Header;
