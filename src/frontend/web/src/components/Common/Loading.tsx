import React from 'react';
import styled from 'styled-components';
import ClipLoader from 'react-spinners/ClipLoader';

const Container = styled.div`
  margin: auto;
`;

export default function Loading() {
  return (
    <Container>
      <ClipLoader color="#6b5ce7" size="100px" loading={true} />
    </Container>
  );
}
