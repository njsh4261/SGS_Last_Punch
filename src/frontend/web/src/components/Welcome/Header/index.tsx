import React from 'react';
import Logo from '../../Common/Logo';
import styled from 'styled-components';
import LogoutButton from './LogoutButton';

const Container = styled.header`
  display: flex;
  justify-content: space-between;
  align-items: end;
  margin: 12px 0;
`;

const EmptyLeft = styled.article`
  margin-left: 104px;
`;

export default function WelcomeHeader() {
  return (
    <Container>
      <EmptyLeft></EmptyLeft>
      <Logo color="black"></Logo>
      <LogoutButton></LogoutButton>
    </Container>
  );
}
