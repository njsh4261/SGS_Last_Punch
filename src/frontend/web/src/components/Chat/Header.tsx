import React from 'react';
import styled from 'styled-components';
import expandIcon from '../../icon/expand.svg';

const ChannelHeader = styled.article`
  display: flex;
  flex-shrink: 0;
  justify-content: space-between;
  padding: 8px 20px;
  border-bottom: 1px solid #e6e6e6;
`;

const ChannelInfo = styled.section`
  width: 100%;
  display: flex;
  &:hover {
    background: #f8f8f8f6;
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

  @media only screen and (max-width: 400px) {
    max-width: 50vw;
  }
  @media only screen and (min-width: 400px) and (max-width: 650px) {
    max-width: 65vw;
  }
  @media only screen and (min-width: 650px) {
    max-width: 80vw;
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

const MemberInfo = styled.button`
  flex: 0 0 auto;
`;

const Header = ({ selectedChannel }: { selectedChannel: string }) => {
  return (
    <ChannelHeader>
      <ChannelInfo>
        <ChannelName>{selectedChannel}</ChannelName>
        <ArrowDropDownIcon></ArrowDropDownIcon>
      </ChannelInfo>

      <MemberInfo>member</MemberInfo>
    </ChannelHeader>
  );
};

export default Header;
