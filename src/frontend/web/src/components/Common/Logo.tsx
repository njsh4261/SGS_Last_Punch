import React from 'react';
import styled from 'styled-components';

const H1 = styled.h1`
  text-align: center;
  color: ${(props) => props.color};
`;

export default function Logo({ color = 'black' }: { color?: string }) {
  return <H1 color={color}>Snack</H1>;
}
