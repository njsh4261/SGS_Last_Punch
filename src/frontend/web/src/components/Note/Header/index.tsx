import React from 'react';
import styled from 'styled-components';
import ImageButton from '../../Common/ImageButton';
import arrowRightIcon from '../../../icon/arrowRight.svg';
import moreIcon from '../../../icon/more.svg';

interface Props {
  sideToggle: boolean;
  toggleHandler: () => void;
}

const Container = styled.div`
  display: flex;
  padding: 16px;
  justify-content: space-between;
  width: 100%;
`;

const LeftContent = styled.div`
  display: flex;
  & > * {
    margin-right: 12px;
  }
`;

const RightContent = styled.div``;

const Path = styled.article`
  display: flex;
  line-height: 0.9;
`;

export default function NoteHeader({ sideToggle, toggleHandler }: Props) {
  return (
    <Container>
      <LeftContent>
        {!sideToggle && (
          <ImageButton
            size="16px"
            imageUrl={arrowRightIcon}
            onClick={toggleHandler}
          ></ImageButton>
        )}
        <Path>
          <div>page1 /</div>
          <div>subpage2 /&nbsp;</div>
          <div>this page</div>
        </Path>
      </LeftContent>
      <RightContent>
        <ImageButton size="16px" imageUrl={moreIcon}></ImageButton>
      </RightContent>
    </Container>
  );
}
