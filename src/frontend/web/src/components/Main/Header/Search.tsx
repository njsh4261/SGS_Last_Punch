import React from 'react';
import styled from 'styled-components';
import { useDispatch } from 'react-redux';
import { openModal, closeModal } from '../../../modules/modal';
import ImageButton from '../../Common/ImageButton';
import SearchIcon from '../../../icon/search.svg';

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

const SearchContainer = ({ workspaceName }: { workspaceName: string }) => {
  const dispatch = useDispatch();
  const handler = () => {
    dispatch(openModal());
  };
  return (
    <ScontainerStyle onClick={handler}>
      <SearchText>{workspaceName} 검색</SearchText>
      <ImageButton size="15px" imageUrl={SearchIcon}></ImageButton>
    </ScontainerStyle>
  );
};

export default SearchContainer;
