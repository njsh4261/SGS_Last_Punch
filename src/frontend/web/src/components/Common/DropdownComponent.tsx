import styled from 'styled-components';

export const Container = styled.div<{ moveX?: boolean }>`
  position: absolute;
  z-index: 1;
  top: 0;
  right: 0;
  transform: translateY(50%) ${({ moveX }) => moveX && 'translateX(70%)'};
  width: 100px;
  border: 1px solid darkgray;
  border-radius: 8px;
  box-shadow: 0 8px 14px rgba(0, 0, 0, 0.35);
  overflow: hidden;
  background-color: white;
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
