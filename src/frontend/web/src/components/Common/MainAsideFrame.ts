import styled from 'styled-components';

const MainAsideFrame = styled.aside`
  min-width: 260px;
  background-color: ${({ theme }) => theme.color.snackSide};
  user-select: none;
`;

export default MainAsideFrame;
