import React, { forwardRef } from 'react';
import styled from 'styled-components';

const Container = styled.article`
  background-color: beige;
  padding: 6px;
`;

const SBlock = styled.input`
  border: none;
  outline: none;
  width: 100%;
`;

interface Props {
  id: string;
  createBlock: (e: React.KeyboardEvent) => void;
}

const Block = forwardRef<HTMLInputElement, Props>(
  ({ id, createBlock }, ref) => {
    return (
      <Container draggable={true}>
        <SBlock id={id} ref={ref} onKeyDown={createBlock}></SBlock>
      </Container>
    );
  },
);
Block.displayName = 'Block';

export default Block;
