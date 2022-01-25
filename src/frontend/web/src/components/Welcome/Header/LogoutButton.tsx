import React from 'react';
import styled from 'styled-components';
import clearSession from '../../../util/clearSession';

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
  const logoutHandler = () => clearSession();
  return <SlogoutButton onClick={logoutHandler}>logout</SlogoutButton>;
}
