import React from 'react';
import { Link } from 'react-router-dom';
import styled from 'styled-components';

const SsignUP = styled.article`
  font-size: 13px;
  text-align: right;
  color: rgba(var(--sk_foreground_max_solid, 97, 96, 97), 1);
`;

const Slink = styled(Link)`
  text-decoration: none;
  color: #1264a3;
  font-weight: 600;
  &:hover {
    cursor: pointer;
    text-decoration: underline;
    font-weight: 700;
  }
`;

export default function SignUp() {
  return (
    <SsignUP>
      Snack을 처음 사용하시나요?
      <br />
      <Slink to="/signup">계정 생성</Slink>
    </SsignUP>
  );
}
