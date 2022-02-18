import React, { useRef } from 'react';
import styled from 'styled-components';

import DropdownHook from '../../../hook/Dropdown';

import ImageButton from '../../Common/ImageButton';
import DropdownSetting from '../Chat/DropdownSetting';

// image files
import arrowRightIcon from '../../../icon/arrowRight.svg';
import logoIcon from '../../../icon/cookie-2.png';
import { updateTitleAPI } from '../../../Api/note';
import { Note } from '../../../../types/note.type';
import { UserState } from '../../../modules/user';

const Container = styled.header`
  display: flex;
  align-items: center;
  justify-content: space-between;
  user-select: none;
`;

const HeaderLeft = styled.div`
  display: flex;
  align-items: center;
`;

const NavTab = styled.nav`
  display: flex;
  align-items: center;
  position: relative;
`;

const NavButton = styled.img`
  cursor: pointer;

  :hover {
    animation: rotate_image 6s linear infinite;
  }
  @keyframes rotate_image {
    100% {
      transform: rotate(360deg);
    }
  }
`;

const H1 = styled.h1`
  margin: 0;
  padding-left: 8px;
`;

const Owner = styled.div`
  margin-right: 10px;
  font-size: 14px;
`;

const InvisibleInput = styled.input`
  width: 0;
  height: 0;
  padding: 0;
  margin: 0;
  border: 0;
`;

interface Props {
  sideToggle: boolean;
  sideToggleHandler: (e: React.MouseEvent<HTMLElement>) => void;
  owner: UserState | null;
  user: UserState;
  note: Note;
  lockNote: () => void;
  unlockNote: () => void;
  title: string;
  setTitle: React.Dispatch<React.SetStateAction<string>>;
  updateTitle: () => void;
  TYPING_TIME: number;
}

export default function Header(props: Props) {
  const {
    sideToggle,
    sideToggleHandler,
    owner,
    user,
    note,
    lockNote,
    unlockNote,
    TYPING_TIME,
    title,
    setTitle,
    updateTitle,
  } = props;
  const typingTitle = useRef<ReturnType<typeof setTimeout> | null>(null);

  const titleHandler = async (e: React.ChangeEvent<HTMLInputElement>) => {
    if (owner === null) {
      lockNote();
    } else if (owner.id === user.id) {
      setTitle(e.target.value);

      if (typingTitle.current) clearTimeout(typingTitle.current);
      typingTitle.current = setTimeout(async () => {
        const success = await updateTitleAPI(note!.id, e.target.value);
        if (success) updateTitle();
        unlockNote();
      }, TYPING_TIME);
    }
  };
  // dropdown
  const { drop, dropdownHandler, NAV_BUTTON_ID, NAV_DROPDOWN_ID } =
    DropdownHook();

  return (
    <Container>
      <HeaderLeft>
        {!sideToggle && (
          <ImageButton
            size="16px"
            imageUrl={arrowRightIcon}
            onClick={sideToggleHandler}
          ></ImageButton>
        )}
        <label htmlFor="title-input">
          <H1>{title}</H1>
        </label>
        <InvisibleInput
          id="title-input"
          value={title}
          onChange={titleHandler}
        ></InvisibleInput>
      </HeaderLeft>
      <NavTab>
        <Owner>{owner && owner.name + '님이 선점 중...'}</Owner>
        <NavButton
          id={NAV_BUTTON_ID}
          src={logoIcon}
          onClick={dropdownHandler}
          width="26px"
          height="26px"
        ></NavButton>
        {drop && <DropdownSetting id={NAV_DROPDOWN_ID}></DropdownSetting>}
      </NavTab>
    </Container>
  );
}
