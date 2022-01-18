import React, { useState } from 'react';
import styled from 'styled-components';

const Container = styled.article`
  display: flex;
  flex-direction: column;
  margin: 0 96px;
  height: 100%;
`;

const ContentHeader = styled.h1`
  outline: none;
`;
const ContentBody = styled.article`
  flex: 1;
  outline: none;
`;

export default function NoteMain() {
  return (
    <Container>
      <ContentHeader contentEditable>1</ContentHeader>
      <ContentBody contentEditable></ContentBody>
    </Container>
  );
}
