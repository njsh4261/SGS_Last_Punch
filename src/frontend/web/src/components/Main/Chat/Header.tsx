import React from 'react';
import styled from 'styled-components';
import expandIcon from '../../../icon/expand.svg';

const ChannelHeader = styled.article`
  display: flex;
  flex-shrink: 0;
  justify-content: space-between;
  padding: 9.5px 20px;
  border-bottom: 1px solid ${({ theme }) => theme.color.snackBorder};
`;

const ChannelInfo = styled.section`
  display: flex;
  border-radius: 4px;
  &:hover {
    background: hsla(0, 0%, 97.25490196078431%, 0.658);
    cursor: pointer;
  }
`;
const ChannelName = styled.article`
  display: block;
  overflow: hidden;
  white-space: nowrap;
  text-overflow: ellipsis;
  font-weight: bold;
  margin-left: -8px;
  border-radius: 6px;
  padding: 3px 8px;
  font-size: 20px;

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

const Header = ({ channelName }: { channelName: string }) => {
  return (
    <ChannelHeader>
      <ChannelInfo>
        <ChannelName>{channelName}</ChannelName>
        <ArrowDropDownIcon></ArrowDropDownIcon>
      </ChannelInfo>
      <div>
        <button>profile</button>
      </div>
    </ChannelHeader>
  );
};

export default Header;
