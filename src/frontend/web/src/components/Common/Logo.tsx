import React from 'react';
import styled from 'styled-components';

import snackIcon from '../../icon/cookie-2.png';

const Container = styled.header`
  text-align: center;
`;

const H1 = styled.h1`
  color: ${(props) => props.color};
  margin: 0;
  margin-left: 6px;
`;

const Img = styled.img<{ size: string }>`
  ${({ size }) => `height: ${size}; width: ${size};`}
  margin: 0;
`;

export default function Logo({
  color = 'black',
  size = '48px',
}: {
  color?: string;
  size?: string;
}) {
  return (
    <Container>
      <Img size={size} src={snackIcon}></Img>
      <H1 color={color}>Snack</H1>
    </Container>
  );
}
