import React from 'react';
import styled from 'styled-components';
import logout from '../../../util/logout';

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
  // 버튼 클릭시 localStorage의 토큰 지우고 페이지 리로드
  return <SlogoutButton onClick={() => logout()}>logout</SlogoutButton>;
}
