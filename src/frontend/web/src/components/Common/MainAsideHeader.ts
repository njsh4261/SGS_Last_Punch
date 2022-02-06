import styled from 'styled-components';

const AsideHeader = styled.header`
  display: flex;
  justify-content: space-between;
  align-items: center;
  width: 260px;
  min-height: 49px;
  color: black;
  font-size: 19px;
  font-weight: 600;
  font-family: sans-serif;
  padding: 12.5px 10px 12.5px 16px;
  border-bottom: 1px solid ${({ theme }) => theme.color.snackBorder};
  cursor: pointer;
`;

export default AsideHeader;
