import styled from 'styled-components';

const MainHeaderFrame = styled.header`
  display: flex;
  justify-content: space-between;
  align-items: center;
  min-height: 38px;
  background-color: ${(props) => props.theme.color.heavySlack};
  padding: 6px 0px;
`;

export default MainHeaderFrame;
