import React, { useState } from 'react';
import styled from 'styled-components';

import ModalBox from '../ModalBox';
import ModalMember from './ModalMember';
import ModalInfo from './ModalInfo';

const Container = styled.div`
  height: 450px;
`;

const Header = styled.header`
  border-bottom: 1px solid lightgray;
  width: 100%;
  padding: 20px 76px 0px 28px;
`;

const HeaderH1 = styled.h1`
  font-size: 28px;
  margin: 0;
  margin-bottom: 15px;
`;

const NavTab = styled.nav`
  display: flex;
`;

interface NavItemProps {
  selected?: boolean;
}

const NavItem = styled.section<NavItemProps>`
  color: 'black';
  margin-right: 20px;
  padding-bottom: 8px;
  opacity: ${({ selected }) => (selected ? '100%' : '50%')};
  box-shadow: ${({ selected }) => selected && 'inset 0 -1.5px 0 0 #007a5a'};
  border-collapse: separate;
  font-weight: 700;
  font-size: 14px;
  :hover {
    opacity: 100%;
  }
`;

const Body = styled.main<{ bgWhite: boolean }>`
  background-color: ${({ bgWhite }) => (bgWhite ? 'white' : '#f6f6f6')};
  padding-bottom: 40px;
`;

export default function ModalMain() {
  const NAV_INFO = 'nav-info';
  const NAV_MEMBER = 'nav-member';

  const [selected, setSelected] = useState({
    info: true,
    member: false,
  });

  const selectHandler = (e: React.MouseEvent<HTMLDivElement>) => {
    const type = (e.target as Element).id;
    switch (type) {
      case NAV_INFO:
        setSelected({ info: true, member: false });
        break;
      case NAV_MEMBER:
        setSelected({ info: false, member: true });
        break;
    }
  };

  return (
    <ModalBox>
      <Container>
        <Header>
          <HeaderH1>channel Name</HeaderH1>
          <NavTab>
            <NavItem
              id={NAV_INFO}
              selected={selected.info}
              onClick={selectHandler}
            >
              정보
            </NavItem>
            <NavItem
              id={NAV_MEMBER}
              selected={selected.member}
              onClick={selectHandler}
            >
              멤버
            </NavItem>
          </NavTab>
        </Header>
        <Body bgWhite={selected.member}>
          {selected.info ? (
            <ModalInfo></ModalInfo>
          ) : (
            <ModalMember></ModalMember>
          )}
        </Body>
      </Container>
    </ModalBox>
  );
}
