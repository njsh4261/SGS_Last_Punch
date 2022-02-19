import styled from 'styled-components';

export const ProfileImage = styled.div<{
  imageNum: number | null;
  size?: string;
}>`
  width: ${({ size }) => (size ? size : '36px')};
  height: ${({ size }) => (size ? size : '36px')};
  background-image: ${({ imageNum }) =>
    `url(${require(`../../images/${imageNum || 12}.png`)})`};
  background-size: contain;
  margin-right: 8px;
  border-radius: 4px;
`;
