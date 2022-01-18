import React from 'react';
import ImageButton from '../../Common/ImageButton';
import ArrowLeftIcon from '../../../icon/arrowLeft.svg';
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

export default function NoteSideHeader({
  hover,
  hoverHandler,
  channelName,
  toggleHandler,
}: Props) {
  return (
    <Container onMouseEnter={hoverHandler} onMouseLeave={hoverHandler}>
      <span>{channelName}의 NOTE</span>
      {hover && (
        <ImageButton
          imageUrl={ArrowLeftIcon}
          onClick={toggleHandler}
          size="16px"
        ></ImageButton>
      )}
    </Container>
  );
}
