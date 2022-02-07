import React, { useState } from 'react';
import styled from 'styled-components';

import MainAsideFrame from '../../Common/MainAsideFrame';
import AsideHeader from '../../Common/MainAsideHeader';
import AsideBody from './Body';
import { RootState } from '../../../modules';
import ImageButton from '../../Common/ImageButton';
import ArrowLeftIcon from '../../../icon/arrowLeft.svg';
import DropdownWorkspace from './DropdownWorkspace';

const DropdownBox = styled.div`
  display: flex;
  position: relative;
`;

const WorkspaceName = styled.div`
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  cursor: pointer;
`;

interface Props {
  ws: RootState['work'];
  hover: boolean;
  hoverHandler: () => void;
  sideToggle: boolean;
  sideToggleHandler: (e: React.MouseEvent<HTMLElement>) => void;
}

export default function Aside({
  ws,
  hover,
  hoverHandler,
  sideToggle,
  sideToggleHandler,
}: Props) {
  const [drop, setDrop] = useState(false);

  const dropdownHandler = () => {
    setDrop((current: boolean) => !current);
  };

  return (
    <MainAsideFrame toggle={sideToggle}>
      <AsideHeader onMouseEnter={hoverHandler} onMouseLeave={hoverHandler}>
        <DropdownBox onClick={dropdownHandler}>
          <WorkspaceName>{ws.name}</WorkspaceName>
          {drop && <DropdownWorkspace></DropdownWorkspace>}
        </DropdownBox>
        {hover && (
          <ImageButton
            imageUrl={ArrowLeftIcon}
            onClick={sideToggleHandler}
            size="16px"
            inline={true}
          ></ImageButton>
        )}
      </AsideHeader>
      <AsideBody></AsideBody>
    </MainAsideFrame>
  );
}
