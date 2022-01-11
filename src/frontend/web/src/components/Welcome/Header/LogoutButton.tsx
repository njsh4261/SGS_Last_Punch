import React from 'react';
import styled from 'styled-components';
import { useNavigate } from 'react-router-dom';

const SlogoutButton = styled.button`
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

export default function LogoutButton() {
  const navigate = useNavigate();
  const logoutHandler = () => {
    sessionStorage.clear();
    navigate('/login');
  };
  return <SlogoutButton onClick={logoutHandler}>logout</SlogoutButton>;
}
