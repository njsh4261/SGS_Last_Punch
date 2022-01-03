import React from 'react';
import styled from 'styled-components';
import SearchIcon from '../../icon/search.svg';

const ScontainerStyle = styled.article`
  flex: 2;
  display: flex;
  justify-content: end;
  border-radius: 4px;
  padding: 0 8px;
  align-items: center;
  background: grey;
  color: white;
  font-size: small;
  &:hover {
    cursor: pointer;
    opacity: 90%;
  }
`;

const SearchText = styled.span`
  width: 100%;
`;

const ImageButton = styled.section<{ imageUrl: string; size?: string }>`
  background-image: url(${(props) => props.imageUrl});
  background-repeat: no-repeat;
  width: ${(props) => props.size || '25px'};
  height: ${(props) => props.size || '25px'};
  border: none;
  outline: none;

  &:hover {
    opacity: 50%;
    cursor: pointer;
  }
`;

const SearchContainer = ({ workspaceName }: { workspaceName: string }) => {
  return (
    <ScontainerStyle>
      <SearchText>{workspaceName} 검색</SearchText>
      <ImageButton size="15px" imageUrl={SearchIcon}></ImageButton>
    </ScontainerStyle>
  );
};

export default SearchContainer;
