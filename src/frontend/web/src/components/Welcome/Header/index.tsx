import React from 'react';
import Logo from '../../Common/Logo';
import styled from 'styled-components';
import { useNavigate } from 'react-router-dom';

const LogoutButton = styled.button`
  color: ${(props) => props.theme.color.slack};
  background-color: white;
  border: none;
  border-radius: 4px;
  outline: none;
  font-weight: bold;
  font-size: 14px;
  height: 38px;
  width: 70px;
  &:hover {
    cursor: pointer;
    opacity: 70%;
  }
`;

const Sheader = styled.header`
  display: flex;
  justify-content: space-between;
  align-items: center;

  & ${LogoutButton} {
    margin-right: 20px;
  }
`;

const EmptyLeft = styled.article``;

export default function WelcomeHeader() {
  const navigate = useNavigate();
  const logoutHandler = () => {
    sessionStorage.clear();
    navigate('/login');
  };

  return (
    <Sheader>
      <EmptyLeft></EmptyLeft>
      <Logo color="white"></Logo>
      <LogoutButton onClick={logoutHandler}>logout</LogoutButton>
    </Sheader>
  );
}
