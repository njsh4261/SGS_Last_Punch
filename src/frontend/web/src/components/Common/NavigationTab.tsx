import React, { useState } from 'react';
import { useDispatch } from 'react-redux';
import { useNavigate, useLocation, useParams } from 'react-router-dom';
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

type NavType = 'CHAT' | 'NOTE' | 'TASK' | 'MEMB';

export default function NavigationTab({ mode }: { mode: NavType }) {
  const navigate = useNavigate();
  const params = useParams();

  const navItems = ['chat', 'note', 'task', 'memb'];

  let initialState;
  if (mode === 'CHAT') initialState = 'chat';
  if (mode === 'NOTE') initialState = 'note';
  if (mode === 'TASK') initialState = 'task';
  // member는 페이지가 아니고 모달이므로 초기값이 필요 없음.

  const [selectedItem] = useState(initialState);
  const selectNavHandler = (e: React.MouseEvent<HTMLDivElement>) => {
    const item = (e.target as Element).id;

    if (item !== selectedItem) {
      const { wsId, channelId } = params;

      if (item === 'chat') navigate(`/${wsId}/${channelId}`);
      if (item === 'note') navigate('note');
      if (item === 'task') navigate('task');
    }
  };

  return (
    <NavContainer>
      {navItems.map((navItem) => (
        <NavItem
          id={navItem}
          key={navItem}
          selected={selectedItem === navItem}
          onClick={selectNavHandler}
        >
          {navItem}
        </NavItem>
      ))}
    </NavContainer>
  );
}
