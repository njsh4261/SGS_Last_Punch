import React from 'react';
import styled from 'styled-components';
import clearSession from '../../../util/clearSession';

const SlogoutButton = styled.button`
  background-color: white;
  border: none;
  border-radius: 4px;
  outline: none;
  font-weight: 500;
  font-size: 14px;
  height: 38px;
  width: 70px;
  margin-right: 64px;
  box-shadow: 1px 1px 2px darkgray;
  &:hover {
    cursor: pointer;
    font-weight: bolder;
    box-shadow: 2px 2px 2px darkgray;
  }
`;

export default function LogoutButton() {
  const logoutHandler = () => clearSession();
  return <SlogoutButton onClick={logoutHandler}>logout</SlogoutButton>;
}
