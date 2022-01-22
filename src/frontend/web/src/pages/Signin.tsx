import React from 'react';
import styled from 'styled-components';
import Signin from '../components/Signin';

const Layout = styled.main`
  position: absolute;
  left: 50%;
  top: 40%;
  transform: translate(-50%, -50%);
`;

export default function SigninPage() {
  return (
    <Layout>
      <Signin></Signin>
    </Layout>
  );
}
