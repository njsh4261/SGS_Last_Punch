import React from 'react';
import styled from 'styled-components';
import { useNavigate } from 'react-router-dom';

import MainHeaderFrame from '../../Common/MainHeaderFrame';
import logoIcon from '../../../icon/cookie-2.png';

const Hlogo = styled.article`
  display: flex;
  padding-left: 16px;
  padding-right: 20px;
  display: position;

  cursor: pointer;

  animation-name: LogoMove;
  animation-duration: 20s;
  animation-direction: alternate;
  animation-iteration-count: infinite;
  animation-timing-function: linear;

  @keyframes LogoMove {
    from {
      margin-right: 0;
    }
    to {
      margin-right: 80%;
    }
  }
`;

const Hright = styled.article`
  flex: 0;
  color: white;
  padding-right: 10px;
`;

const Logo = styled.img`
  width: 26px;
  height: 26px;
`;

export default function MainHeader() {
  const navigate = useNavigate();
  return (
    <MainHeaderFrame>
      <Hlogo onClick={() => navigate('/')}>
        <Logo src={logoIcon}></Logo>
      </Hlogo>
      <Hright>
        <button>profile</button>
      </Hright>
    </MainHeaderFrame>
  );
}
