import React from 'react';
import styled from 'styled-components';

import MainAsideFrame from '../../Common/MainAsideFrame';
import AsideHeader from '../../Common/MainAsideHeader';
import AsideBody from './Body';
import { RootState } from '../../../modules';
import ImageButton from '../../Common/ImageButton';
import ArrowLeftIcon from '../../../icon/arrowLeft.svg';

const WorkspaceName = styled.div`
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
`;

interface Props {
  ws: RootState['work'];
  hover: boolean;
  hoverHandler: () => void;
  sideToggleHandler: (e: React.MouseEvent<HTMLElement>) => void;
}

export default function Aside({
  ws,
  hover,
  hoverHandler,
  sideToggleHandler,
}: Props) {
  return (
    <MainAsideFrame>
      <AsideHeader
        onMouseEnter={hoverHandler}
        onMouseLeave={hoverHandler}
        onClick={() => alert('todo: ws setting')}
      >
        <WorkspaceName>{ws.name}</WorkspaceName>
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
