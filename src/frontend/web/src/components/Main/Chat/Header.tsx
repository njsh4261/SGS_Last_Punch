import React from 'react';
import styled from 'styled-components';

import DropdownHook from '../../../hook/Dropdown';
import logoIcon from '../../../icon/cookie-2.png';
import expandIcon from '../../../icon/expand.svg';
import ImageButton from '../../Common/ImageButton';
import arrowRightIcon from '../../../icon/arrowRight.svg';
import DropdownSetting from './DropdownSetting';
import ModalMenuHook from '../../../hook/ModalMenu';
import ModalMenu from '../Modal';
import { RootState } from '../../../modules';
import ModalStatus from '../Modal/ModalStatus';
import { UserStatus } from '../../../../types/presence';

const ChannelHeader = styled.article`
  display: flex;
  flex-shrink: 0;
  justify-content: space-between;
  padding: 9.5px 20px;
  user-select: none;
  border-bottom: 1px solid lightgray;
`;

const ChannelInfo = styled.section`
  display: flex;
  align-items: center;
  border-radius: 4px;
  &:hover {
    cursor: pointer;
    background-color: #f6f6f6;
  }
`;
const ChannelName = styled.article`
  display: block;
  overflow: hidden;
  white-space: nowrap;
  text-overflow: ellipsis;
  font-weight: bold;
  border-radius: 6px;
  padding: 3px 8px;
  font-size: 20px;

  * + & {
    padding-left: 16px;
  }

  @media only screen and (max-width: 900px) {
    max-width: 45vw;
  }
  @media only screen and (min-width: 900px) and (max-width: 1100px) {
    max-width: 55vw;
  }
  @media only screen and (min-width: 1100px) {
    max-width: 65vw;
  }
`;

const ChannelTopic = styled.div`
  opacity: 50%;
  font-size: 14px;
`;

const ArrowDropDownIcon = styled.article`
  display: inline-block;
  width: 20px;
  height: 20px;
  align-self: center;
  margin-right: 6px;
  background-image: url(${expandIcon});
  background-repeat: no-repeat;
`;

const NavTab = styled.nav`
  display: flex;
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

const ChannelTab = styled.div`
  display: flex;
  align-items: center;
  position: relative;
`;

interface Props {
  channel: RootState['channel'];
  sideToggle: boolean;
  sendMessage: (userStatus: UserStatus) => void;
  sideToggleHandler: (e: React.MouseEvent<HTMLElement>) => void;
}

const Header = ({
  channel,
  sendMessage,
  sideToggle,
  sideToggleHandler,
}: Props) => {
  const TYPE = 'channel';

  const { drop, dropdownHandler, NAV_BUTTON_ID, NAV_DROPDOWN_ID } =
    DropdownHook();

  const { modal, openModalHandler } = ModalMenuHook({ type: TYPE });

  return (
    <ChannelHeader>
      {modal.active && modal.modalType === 'channel' && (
        <ModalMenu type={TYPE}></ModalMenu>
      )}
      {modal.active && modal.modalType === 'profile' && (
        <ModalStatus sendMessage={sendMessage}></ModalStatus>
      )}
      <ChannelInfo>
        {!sideToggle && (
          <ImageButton
            size="16px"
            imageUrl={arrowRightIcon}
            onClick={sideToggleHandler}
          ></ImageButton>
        )}
        <ChannelTab
          onClick={
            channel.id.toString().includes('-') ? undefined : openModalHandler
          }
        >
          <ChannelName>{channel.name}</ChannelName>
          <ChannelTopic>{channel.topic}</ChannelTopic>
          <ArrowDropDownIcon></ArrowDropDownIcon>
        </ChannelTab>
      </ChannelInfo>
      <NavTab>
        <NavButton
          id={NAV_BUTTON_ID}
          src={logoIcon}
          onClick={dropdownHandler}
          width="26px"
          height="26px"
        ></NavButton>
        {drop && <DropdownSetting id={NAV_DROPDOWN_ID}></DropdownSetting>}
      </NavTab>
    </ChannelHeader>
  );
};

export default Header;
