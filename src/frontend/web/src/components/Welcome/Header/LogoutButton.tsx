import React from 'react';
import styled from 'styled-components';

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
  margin-right: 64px;
  &:hover {
    cursor: pointer;
    opacity: 70%;
  }
`;

export default function LogoutButton() {
  const logoutHandler = () => {
    sessionStorage.clear();
    location.reload();
  };
  return <SlogoutButton onClick={logoutHandler}>logout</SlogoutButton>;
}
