import React from 'react';
import styled from 'styled-components';
import { useNavigate } from 'react-router-dom';

const WelcomePage = styled.div`
  background-color: ${(props) => props.theme.color.slack};
  height: 100%;
`;

export default function Welcome() {
  const navigate = useNavigate();
  const logoutHandler = () => {
    sessionStorage.clear();
    navigate('/login');
  };
  return (
    <WelcomePage>
      <span>login success</span>
      <button onClick={logoutHandler}>logout</button>
    </WelcomePage>
  );
}
