import React from 'react';
import styled from 'styled-components';
import MainAsideFrame from '../../Common/MainAsideFrame';
import AsideHeader from '../../Common/MainAsideHeader';

export default function Aside() {
  const wsName = 'default'; // todo: redux store
  return (
    <MainAsideFrame>
      <AsideHeader>{wsName} tttttttttttttttt tttttttttttttttt</AsideHeader>
    </MainAsideFrame>
  );
}
