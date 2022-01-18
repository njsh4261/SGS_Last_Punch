import React from 'react';
import styled from 'styled-components';

interface Props {
  hover: boolean;
  hoverHandler: () => void;
  channelName: string;
  toggleHandler: () => void;
}
const Container = styled.div`
  color: black;
  padding: 14px;
  display: flex;
  justify-content: space-between;
  overflow: hidden;
  &:hover {
    background-color: #e8e7e4;
  }
`;

const ToggleButton = styled.button`
  background: none;
  border: none;
  outline: none;
  font-weight: 900;
  cursor: pointer;
`;

export default function NoteSideHeader({
  hover,
  hoverHandler,
  channelName,
  toggleHandler,
}: Props) {
  return (
    <Container onMouseEnter={hoverHandler} onMouseLeave={hoverHandler}>
      <span>{channelName}의 NOTE</span>
      {hover && <ToggleButton onClick={toggleHandler}>hide</ToggleButton>}
    </Container>
  );
}
