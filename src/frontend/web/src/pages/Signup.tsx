import React from 'react';
import styled from 'styled-components';
import SignupEmailContainer from '../components/SignupEmail';

const LoginLayout = styled.main`
  position: absolute;
  left: 50%;
  top: 40%;
  transform: translate(-50%, -50%);
`;

export default function Signup() {
  return (
    <LoginLayout>
      <SignupEmailContainer></SignupEmailContainer>
    </LoginLayout>
  );
}
