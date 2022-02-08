import styled, { css } from 'styled-components';

export const Container = styled.div<{ left?: boolean }>`
  position: absolute;
  z-index: 1;
  top: 0;
  transform: translateY(50%);
  width: 100px;
  font-size: 16px;
  border: 1px solid darkgray;
  border-radius: 8px;
  box-shadow: 0 8px 14px rgba(0, 0, 0, 0.35);
  overflow: hidden;
  background-color: white;
  ${({ left }) =>
    left
      ? css`
          left: 0;
        `
      : css`
          right: 0; ;
        `}
`;

export const Layer = styled.article<{ color?: string }>`
  border-bottom: 1px solid lightgray;
  text-align: center;
  padding: 4px 0;
  color: ${({ color }) => color};
  :hover {
    cursor: pointer;
    background-color: lightgray;
  }
`;
