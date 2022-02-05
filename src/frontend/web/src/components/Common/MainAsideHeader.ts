import styled from 'styled-components';

const AsideHeader = styled.div`
  display: block;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  width: 260px;
  min-height: 49px;
  color: black;
  font-size: 19px;
  font-weight: 600;
  font-family: sans-serif;
  padding: 12.5px 40px 12.5px 16px;
  border-bottom: 1px solid ${({ theme }) => theme.color.snackBorder};
  cursor: pointer;
`;

export default AsideHeader;
