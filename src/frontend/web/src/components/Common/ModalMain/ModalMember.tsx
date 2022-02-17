import React, { useEffect, useState } from 'react';
import styled, { css } from 'styled-components';
import { Params } from 'react-router-dom';
import { useDispatch, useSelector } from 'react-redux';

import seacrhImage from '../../../icon/search.svg';
import addPersonImage from '../../../icon/addPerson.svg';
import { getChannelMember } from '../../../Api/channel';
import Loading from '../Loading';
import { getWsMemberAPI } from '../../../Api/workspace';
import { openModal } from '../../../modules/modal';
import { UserStatus } from '../../../../types/presence';
import { RootState } from '../../../modules';
import StatusCircle from '../StatusCircle';

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
  status: UserStatus;
}

export default function ModalMember({ type, params }: Props) {
  const dispatch = useDispatch();
  const [focus, setFocus] = useState(false);
  // 검색 입력 값 상태
  const [searchValue, setSearchValue] = useState('');
  // 채널 혹은 워크스페이스의 멤버 리스트. API로 새로 받아온다
  const [memberList, setMemberList] = useState<Member[]>([]);
  // 멤버 검색 결과 리스트
  const [searchList, setSearchList] = useState<Member[]>([]);
  // store에 저장된 워크스페이스 멤버 리스트 (상태 값 조회를 위해)
  const wsMemberListWithStatus = useSelector(
    (state: RootState) => state.userList,
  );

  // 응답으로 온 채널의 멤버에 status를 관리하는 리스트를 합친다.
  const combineStatus = (responseListWithoutStatus: any) => {
    const combineList = [];
    for (let i = 0; i < responseListWithoutStatus.length; i += 1) {
      for (let j = 0; j < wsMemberListWithStatus.length; j += 1) {
        const withoutStatus = responseListWithoutStatus[i];
        const withStatus = wsMemberListWithStatus[j];
        if (withoutStatus.id === withStatus.id) {
          if (withStatus.status) {
            combineList.push({
              ...withoutStatus,
              status: withStatus.status,
            });
          } else {
            // offline
            combineList.push({ ...withoutStatus, status: 'OFFLINE' });
          }
          break;
        }
      }
    }
    setMemberList(combineList);
  };

  const getMemberListHandler = async () => {
    if (type === 'channel') {
      if (params.channelId) {
        const response = await getChannelMember(params.channelId);
        combineStatus(response.members.content);
      }
    } else {
      if (params.wsId) {
        const response = await getWsMemberAPI(+params.wsId);
        combineStatus(response.members.content);
      }
    }
  };

  const searchHandler = (e: React.ChangeEvent<HTMLInputElement>) => {
    const { value } = e.target;
    setSearchValue(value);
    if (value === '') {
      setSearchList([]);
      return;
    }
    const searchedList = memberList.filter((member) =>
      member.name.includes(value),
    );
    setSearchList(searchedList);
  };

  const openInviteModalHandler = () => {
    console.log('invite click');
    if (type === 'channel') {
      dispatch(openModal('invite-channel'));
    } else {
      dispatch(openModal('invite-workspace'));
    }
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
              value={searchValue}
              placeholder="멤버 찾기"
            ></Input>
          </SearchBar>
          <Layer>
            <ImageIcon src={addPersonImage}></ImageIcon>
            <div onClick={openInviteModalHandler}>사용자 추가</div>
          </Layer>
          <MemberLayers>
            {searchValue === ''
              ? memberList.map((member) => (
                  <Layer key={`member-${member.id}`}>
                    <ImageIcon src={addPersonImage}></ImageIcon>
                    <StatusCircle status={member.status}></StatusCircle>
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
