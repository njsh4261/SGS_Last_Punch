import React from 'react';
import MainAsideFrame from '../../Common/MainAsideFrame';
import AsideHeader from '../../Common/MainAsideHeader';
import AsideBody from './Body';

export default function Aside() {
  const wsName = 'default'; // todo: redux store
  return (
    <MainAsideFrame>
      <AsideHeader>{wsName} tttttttttttttttt tttttttttttttttt</AsideHeader>
      <AsideBody></AsideBody>
    </MainAsideFrame>
  );
}
