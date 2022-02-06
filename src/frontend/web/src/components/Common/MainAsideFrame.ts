import styled from 'styled-components';

const MainAsideFrame = styled.aside<{ toggle?: boolean }>`
  width: ${({ toggle }) => (toggle ? '260px' : '0px')};
  overflow-x: hidden;
  white-space: nowrap;
  background-color: ${({ theme }) => theme.color.lightGrey};
  user-select: none;
  transition: width 300ms;
  overflow-y: scroll;
`;

export default MainAsideFrame;
