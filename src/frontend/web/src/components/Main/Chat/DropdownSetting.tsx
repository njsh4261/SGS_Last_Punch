import React, { useMemo } from 'react';
import { useNavigate } from 'react-router-dom';
import { useDispatch, useSelector } from 'react-redux';
import styled from 'styled-components';

import logout from '../../../util/logout';
import { Container, Layer } from '../../Common/DropdownComponent';
import StatusCircle from '../../Common/StatusCircle';
import { openModal } from '../../../modules/modal';
import { RootState } from '../../../modules';
import { ProfileImage } from '../../Common/ProfileImage';

const Profile = styled.div`
  display: flex;
`;

const ProfileNameAndStatus = styled.div`
  display: flex;
  flex-direction: column;
`;

const ProfileName = styled.div`
  font-weight: bolder;
  font-size: 16px;
  padding-bottom: 2px;
`;

const ProfileStatus = styled.div`
  font-weight: 300;
  font-size: 12px;
  display: flex;
  align-items: center;
  padding-top: 2px;
  & > * {
    margin-right: 6px;
  }
`;

export default function Dropdown({ id }: { id: string }) {
  const navigate = useNavigate();
  const dispatch = useDispatch();
  const user = useSelector((state: RootState) => state.user);
  const presence = useSelector((state: RootState) => state.presence);
  const status = useMemo(() => presence[user.id], [user, presence]);

  return (
    <Container id={id}>
      <Layer onClick={() => dispatch(openModal('profile'))}>
        <Profile>
          <ProfileImage imageNum={user.imageNum || null}></ProfileImage>
          <ProfileNameAndStatus>
            <ProfileName>{user.name}</ProfileName>
            <ProfileStatus>
              <StatusCircle status={status || 'ONLINE'}></StatusCircle>
              {status === 'ONLINE'
                ? '온라인'
                : status === 'BUSY'
                ? '업무 중'
                : status === 'ABSENT'
                ? '자리 비움'
                : '오프라인'}
            </ProfileStatus>
          </ProfileNameAndStatus>
        </Profile>
      </Layer>
      <Layer onClick={() => navigate('/')}>Home으로</Layer>
      <Layer onClick={() => logout()} color="red">
        Logout
      </Layer>
    </Container>
  );
}
