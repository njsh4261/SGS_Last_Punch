import React, { forwardRef } from 'react';
import styled from 'styled-components';

const Container = styled.article`
  padding: 6px;
  background-color: #e8e7e4;
`;

const SBlock = styled.input`
  border: none;
  outline: none;
  width: 100%;
  /* font-weight: 900; // strong */
  /* font-style: italic; // italic */
  /* text-decoration: underline; // underline */
  /* text-decoration: line-through; // 취소선; */
  /* color: red; // font-color */
  background-color: #e8e7e4; // highlight
`;

interface Props {
  id: string;
  createBlock: (e: React.KeyboardEvent) => void;
}

const Block = forwardRef<HTMLInputElement, Props>(
  ({ id, createBlock }, ref) => {
    return (
      <Container draggable={true}>
        <SBlock
          id={id}
          ref={ref}
          onKeyDown={createBlock}
          autoComplete="off"
        ></SBlock>
      </Container>
    );
  },
);
Block.displayName = 'Block';

export default Block;
