import React from 'react';
import MainAsideFrame from '../../Common/MainAsideFrame';
import AsideHeader from '../../Common/MainAsideHeader';
import AsideBody from './Body';

export default function Aside({ wsName }: { wsName: string }) {
  return (
    <MainAsideFrame>
      <AsideHeader>{wsName}</AsideHeader>
      <AsideBody></AsideBody>
    </MainAsideFrame>
  );
}
