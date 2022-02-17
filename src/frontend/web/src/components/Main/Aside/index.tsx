import React from 'react';
import styled from 'styled-components';

import MainAsideFrame from '../../Common/MainAsideFrame';
import AsideHeader from '../../Common/MainAsideHeader';
import AsideBody from './Body';
import { RootState } from '../../../modules';
import ImageButton from '../../Common/ImageButton';
import ArrowLeftIcon from '../../../icon/arrowLeft.svg';
import { WorkspaceName } from '../../Common/WorkspaceName';
import ModalMenuHook from '../../../hook/ModalMenu';
import ModalMain from '../Modal';

const ModalBox = styled.div`
  display: flex;
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
  const { modal, openModalHandler } = ModalMenuHook({ type: 'workspace' });

  return (
    <MainAsideFrame toggle={sideToggle}>
      {modal.active && modal.modalType === 'workspace' && (
        <ModalMain type="workspace"></ModalMain>
      )}
      <AsideHeader onMouseEnter={hoverHandler} onMouseLeave={hoverHandler}>
        <ModalBox onClick={openModalHandler}>
          <WorkspaceName>{ws.name}</WorkspaceName>
        </ModalBox>
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
