import styled from 'styled-components';

const ImageButton = styled.section<{
  imageUrl: string;
  size?: string;
  inline?: boolean;
}>`
  background-image: url(${(props) => props.imageUrl});
  background-repeat: no-repeat;
  width: ${(props) => props.size || '25px'};
  height: ${(props) => props.size || '25px'};
  border: none;
  outline: none;
  display: ${(props) => (props.inline ? 'inline-block' : 'block')};

  & + & {
    margin-left: 10px;
  }

  &:hover {
    opacity: 50%;
    cursor: pointer;
  }
`;

export default ImageButton;
