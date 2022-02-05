import React from 'react';
import { useNavigate } from 'react-router-dom';

import MainAsideFrame from '../../Common/MainAsideFrame';
import AsideHeader from '../../Common/MainAsideHeader';
import AsideBody from './Body';
import { RootState } from '../../../modules';

export default function Aside({ ws }: { ws: RootState['work'] }) {
  const navigate = useNavigate();

  return (
    <MainAsideFrame>
      <AsideHeader onClick={() => navigate(`/${ws.id}`)}>{ws.name}</AsideHeader>
      <AsideBody></AsideBody>
    </MainAsideFrame>
  );
}
