import React from 'react';
import styled from 'styled-components';
import LoginEmailContainer from '../components/LoginEmail';

const LoginLayout = styled.main`
  position: absolute;
  left: 50%;
  top: 40%;
  transform: translate(-50%, -50%);
`;

export default function Login() {
  return (
    <LoginLayout>
      <LoginEmailContainer></LoginEmailContainer>
    </LoginLayout>
  );
}
