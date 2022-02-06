import React from 'react';
import styled from 'styled-components';
import { useNavigate } from 'react-router-dom';

import MainAsideFrame from '../../Common/MainAsideFrame';
import AsideHeader from '../../Common/MainAsideHeader';
import AsideBody from './Body';
import { RootState } from '../../../modules';
import logoIcon from '../../../icon/cookie-2.png';

const Footer = styled.footer`
  position: absolute;
  bottom: 0;
  right: 0;
`;

const Logo = styled.article`
  padding-right: 20px;
  padding-bottom: 45px;

  cursor: pointer;

  animation-name: LogoMove;
  animation-duration: 20s;
  animation-direction: alternate;
  animation-iteration-count: infinite;
  animation-timing-function: linear;

  @keyframes LogoMove {
    from {
      margin-right: 0px;
      transform: rotate(0deg);
    }
    to {
      margin-right: 200px;
      transform: rotate(360deg);
    }
  }
`;

export default function Aside({ ws }: { ws: RootState['work'] }) {
  const navigate = useNavigate();

  return (
    <MainAsideFrame>
      <AsideHeader onClick={() => alert('todo: ws setting')}>
        {ws.name}
      </AsideHeader>
      <AsideBody></AsideBody>
      <Footer>
        <Logo onClick={() => navigate('/')}>
          <img src={logoIcon} width="26px" height="26px"></img>
        </Logo>
      </Footer>
    </MainAsideFrame>
  );
}
