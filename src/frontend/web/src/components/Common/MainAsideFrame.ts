import styled from 'styled-components';

const MainAsideFrame = styled.aside<{ toggle?: boolean }>`
  width: ${({ toggle }) => (toggle ? '260px' : '0px')};
  overflow-x: hidden;
  white-space: nowrap;
  background-color: ${({ theme }) => theme.color.snackSide};
  user-select: none;
  transition: width 300ms;
  overflow-y: scroll;
  border-right: 1px solid ${({ theme }) => theme.color.snackBorder};
`;

export default MainAsideFrame;
