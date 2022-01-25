import React from 'react';
import styled from 'styled-components';

const Container = styled.article`
  padding: 14px;
`;

const Item = styled.section`
  & + & {
    margin-top: 10px;
  }
`;

export default function NoteSideMenu() {
  return (
    <Container>
      <Item>Quick Find</Item>
      <Item>All Updates</Item>
      <Item>Setting & Members</Item>
    </Container>
  );
}
