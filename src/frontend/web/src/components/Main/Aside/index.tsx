import React from 'react';
import { useSelector } from 'react-redux';
import { RootState } from '../../../modules';
import MainAsideFrame from '../../Common/MainAsideFrame';
import AsideHeader from '../../Common/MainAsideHeader';
import AsideBody from './Body';

export default function Aside() {
  const wsName = useSelector((state: RootState) => state.work.name);
  return (
    <MainAsideFrame>
      <AsideHeader>{wsName} tttttttttttttttt tttttttttttttttt</AsideHeader>
      <AsideBody></AsideBody>
    </MainAsideFrame>
  );
}
