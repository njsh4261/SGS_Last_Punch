import styled from 'styled-components';

const MainAsideFrame = styled.aside`
  width: 260px;
  overflow: hidden;
  white-space: nowrap;
  background-color: ${({ theme }) => theme.color.snackSide};
  user-select: none;
  transition: width 300ms;
  position: relative;
`;

export default MainAsideFrame;
