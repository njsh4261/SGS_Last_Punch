import React from 'react';
import styled from 'styled-components';

import DropdownHook from '../../../hook/Dropdown';
import logoIcon from '../../../icon/cookie-2.png';
import expandIcon from '../../../icon/expand.svg';
import ImageButton from '../../Common/ImageButton';
import arrowRightIcon from '../../../icon/arrowRight.svg';
import DropdownSetting from './DropdownSetting';
import DropdownChannel from './DropdownChannel';

const ChannelHeader = styled.article`
  display: flex;
  flex-shrink: 0;
  justify-content: space-between;
  padding: 9.5px 20px;
  /* border-bottom: 1px solid ${({ theme }) => theme.color.snackBorder}; */
`;

const ChannelInfo = styled.section`
  display: flex;
  align-items: center;
  border-radius: 4px;
  &:hover {
    cursor: pointer;
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
const ArrowDropDownIcon = styled.article`
  display: inline-block;
  width: 20px;
  height: 20px;
  align-self: center;
  margin-right: 14px;
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
  position: relative;
`;

interface Props {
  channel: any;
  sideToggle: boolean;
  sideToggleHandler: (e: React.MouseEvent<HTMLElement>) => void;
}

const Header = ({ channel, sideToggle, sideToggleHandler }: Props) => {
  const {
    drop,
    channelDrop,
    dropdownHandler,
    NAV_BUTTON_ID,
    NAV_DROPDOWN_ID,
    CHANNEL_BUTTON_CLASSNAME,
    CHANNEL_DROPDOWN_ID,
  } = DropdownHook();

  return (
    <ChannelHeader>
      <ChannelInfo>
        {!sideToggle && (
          <ImageButton
            size="16px"
            imageUrl={arrowRightIcon}
            onClick={sideToggleHandler}
          ></ImageButton>
        )}
        <ChannelTab
          className={CHANNEL_BUTTON_CLASSNAME}
          onClick={dropdownHandler}
        >
          <ChannelName className={CHANNEL_BUTTON_CLASSNAME}>
            {channel.name}
          </ChannelName>
          <ArrowDropDownIcon
            className={CHANNEL_BUTTON_CLASSNAME}
          ></ArrowDropDownIcon>
          {channelDrop && (
            <DropdownChannel
              channelId={channel.id}
              id={CHANNEL_DROPDOWN_ID}
            ></DropdownChannel>
          )}
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
