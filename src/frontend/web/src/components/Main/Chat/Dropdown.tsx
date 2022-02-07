import React from 'react';
import styled from 'styled-components';

const Container = styled.div`
  position: absolute;
  z-index: 1;
  top: 0;
  right: 0;
  transform: translateY(50%);
  width: 100px;
  height: 100px;
  border: 1px solid darkgray;
  border-radius: 8px;
  box-shadow: 0 8px 14px rgba(0, 0, 0, 0.35);
`;

export default Container;
