import React from 'react';
import Logo from '../../Common/Logo';
import styled from 'styled-components';
import LogoutButton from './LogoutButton';

const Sheader = styled.header`
  display: flex;
  justify-content: space-between;
  align-items: center;
`;

const EmptyLeft = styled.article`
  margin-left: 104px;
`;

export default function WelcomeHeader() {
  return (
    <Sheader>
      <EmptyLeft></EmptyLeft>
      <Logo color="white"></Logo>
      <LogoutButton></LogoutButton>
    </Sheader>
  );
}
