import styled from 'styled-components';

const MainAsideFrame = styled.aside<{ toggle?: boolean }>`
  width: ${({ toggle }) => (toggle ? '260px' : '0px')};
  flex: 0 0 auto;
  overflow-x: hidden;
  overflow-y: hidden;
  white-space: nowrap;
  background-color: ${({ theme }) => theme.color.snackSide};
  user-select: none;
  transition: width 300ms;
  :hover,
  :focus {
    overflow-y: auto;
  }
`;

export default MainAsideFrame;
