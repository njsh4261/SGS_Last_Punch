import styled from 'styled-components';

const MainHeaderFrame = styled.header`
  display: flex;
  justify-content: end;
  align-items: center;
  min-height: 38px;
  background-color: ${({ theme }) => theme.color.snackHeader};
  padding: 6px 0px;
`;

export default MainHeaderFrame;
