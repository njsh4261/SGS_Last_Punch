import styled from 'styled-components';

const MainAsideFrame = styled.aside`
  min-width: 260px;
  background-color: ${({ theme }) => theme.color.snackSide};
  border-top: 1px solid ${({ theme }) => theme.color.snackBorder};
  user-select: none;
`;

export default MainAsideFrame;
