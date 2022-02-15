import React, { useEffect, useState } from 'react';
import styled, { css } from 'styled-components';
import { Params } from 'react-router-dom';
import cloneDeep from 'lodash/cloneDeep';

import seacrhImage from '../../../icon/search.svg';
import addPersonImage from '../../../icon/addPerson.svg';
import { getChannelMember } from '../../../Api/channel';
import Loading from '../Loading';
import { getWsMemberAPI } from '../../../Api/workspace';

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
  border-top: 1px solid lightgray;
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

const MemberName = styled.section`
  display: inline-block;
`;

const MemberEmail = styled.section`
  display: inline-block;
  opacity: 40%;
  margin-left: 4px;
`;

interface Props {
  type: 'channel' | 'workspace';
  params: Params;
}

interface Member {
  id: number;
  name: string;
  email: string;
}

export default function ModalMember({ type, params }: Props) {
  const [focus, setFocus] = useState(false);

  // 채널 혹은 워크스페이스의 멤버리스트. API로 새로 받아온다
  const [memberList, setMemberList] = useState<Member[]>([]);

  const [searchList, setSearchList] = useState<Member[]>([]);

  const getMemberListHandler = async () => {
    if (type === 'channel') {
      if (params.channelId) {
        const response = await getChannelMember(params.channelId);
        setMemberList(cloneDeep(response.members.content));
      }
    } else {
      if (params.wsId) {
        const response = await getWsMemberAPI(+params.wsId);
        setMemberList(cloneDeep(response.members.content));
      }
    }
  };

  const searchHandler = (e: React.ChangeEvent<HTMLInputElement>) => {
    const { value } = e.target;
    if (value === '') {
      setSearchList([]);
      return;
    }
    const searchedList = memberList.filter((member) =>
      member.name.includes(value),
    );
    setSearchList(searchedList);
  };

  useEffect(() => {
    getMemberListHandler();
  }, []);

  return (
    <>
      {memberList.length === 0 ? (
        <Loading></Loading>
      ) : (
        <Container>
          <SearchBar focus={focus}>
            <SearchIcon src={seacrhImage}></SearchIcon>
            <Input
              onFocus={() => setFocus(true)}
              onBlur={() => setFocus(false)}
              onChange={searchHandler}
              placeholder="멤버 찾기"
            ></Input>
          </SearchBar>
          <Layer>
            <ImageIcon src={addPersonImage}></ImageIcon>
            <div>사용자 추가</div>
          </Layer>
          <MemberLayers>
            {searchList.length === 0
              ? memberList.map((member) => (
                  <Layer key={`member-${member.id}`}>
                    <ImageIcon src={addPersonImage}></ImageIcon>
                    <MemberName>{member.name}</MemberName>
                    <MemberEmail>{member.email}</MemberEmail>
                  </Layer>
                ))
              : searchList.map((member) => (
                  <Layer key={`member-${member.id}`}>
                    <ImageIcon src={addPersonImage}></ImageIcon>
                    <MemberName>{member.name}</MemberName>
                    <MemberEmail>{member.email}</MemberEmail>
                  </Layer>
                ))}
          </MemberLayers>
        </Container>
      )}
    </>
  );
}
