import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import styled from 'styled-components';

const NavContainer = styled.nav`
  border-radius: 4px;
  border: 1px solid ${({ theme }) => theme.color.lightGrey};
  display: flex;
`;

const NavItem = styled.section<{ selected: boolean }>`
  padding: 3px 8px;
  & + & {
    border: 1px solid ${({ theme }) => theme.color.lightGrey};
  }

  ${(props) =>
    props.selected
      ? `
    background-color: skyblue;
  `
      : `
    &:hover {
      background-color: ${props.theme.color.lightGrey};
    }
  `}
`;

export default function Navigation() {
  const navigate = useNavigate();

  // dummy
  const navItems = [
    { id: '1', name: 'chat' },
    { id: '2', name: 'note' },
    { id: '3', name: 'task' },
    { id: '4', name: 'memb' },
  ];
  const [selectedId, selectId] = useState('1');
  const selectNavHandler = (e: React.MouseEvent<HTMLDivElement>) => {
    const { id } = e.target as Element;
    selectId(id);
    navigate(id);
  };

  return (
    <NavContainer>
      {navItems.map((navItem) => (
        <NavItem
          id={navItem.id}
          key={navItem.id}
          selected={selectedId === navItem.id}
          onClick={selectNavHandler}
        >
          {navItem.name}
        </NavItem>
      ))}
    </NavContainer>
  );
}
