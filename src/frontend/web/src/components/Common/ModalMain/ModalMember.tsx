import React, { useState } from 'react';
import styled, { css } from 'styled-components';

import seacrhImage from '../../../icon/search.svg';
import addPersonImage from '../../../icon/addPerson.svg';

const Container = styled.article`
  border-radius: 6px;
`;

const SearchBar = styled.div<{ focus: boolean }>`
  display: flex;
  align-items: center;
  margin: 14px 28px;
  padding: 10px;
  border: 1px solid lightgray;
  border-radius: 4px;

  ${({ focus }) =>
    focus &&
    css`
      border: 1px solid rgb(29, 155, 209);
      box-shadow: 0px 0px 0px 3px rgba(29, 155, 209, 0.3);
    `}
`;

const SearchIcon = styled.img`
  width: 14px;
  height: 14px;
  margin-right: 8px;
`;

const Input = styled.input`
  width: 100%;
  border: none;
  outline: none;
  background-color: inherit;
  font-size: 14px;
`;

const MemberLayers = styled.article`
  height: 200px;
  overflow: hidden;
  :hover {
    overflow-y: auto;
  }
`;

const Layer = styled.section`
  display: flex;
  align-items: center;
  padding: 8px 28px;
  :hover {
    background-color: #ececec;
  }
`;

const ImageIcon = styled.img`
  width: 36px;
  height: 36px;
  padding: 2px;
  margin-right: 8px;
`;

export default function ModalMember() {
  const [focus, setFocus] = useState(false);
  return (
    <Container>
      <SearchBar focus={focus}>
        <SearchIcon src={seacrhImage}></SearchIcon>
        <Input
          onFocus={() => setFocus(true)}
          onBlur={() => setFocus(false)}
          placeholder="멤버 찾기"
        ></Input>
      </SearchBar>
      <Layer>
        <ImageIcon src={addPersonImage}></ImageIcon>
        <div>사용자 추가</div>
      </Layer>
      <MemberLayers>
        {/** test */}
        <Layer>
          <ImageIcon src={addPersonImage}></ImageIcon>
          <div>사용자 추가</div>
        </Layer>
        <Layer>
          <ImageIcon src={addPersonImage}></ImageIcon>
          <div>사용자 추가</div>
        </Layer>
        <Layer>
          <ImageIcon src={addPersonImage}></ImageIcon>
          <div>사용자 추가</div>
        </Layer>
        <Layer>
          <ImageIcon src={addPersonImage}></ImageIcon>
          <div>사용자 추가1</div>
        </Layer>
        <Layer>
          <ImageIcon src={addPersonImage}></ImageIcon>
          <div>사용자 추가1</div>
        </Layer>
      </MemberLayers>
    </Container>
  );
}
