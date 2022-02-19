import React from 'react';
import { useNavigate } from 'react-router-dom';
import { useDispatch, useSelector } from 'react-redux';
import styled from 'styled-components';

import logout from '../../../util/logout';
import { Container, Layer } from '../../Common/DropdownComponent';
import cookieImage from '../../../icon/cookie-2.png';
import StatusCircle from '../../Common/StatusCircle';
import { openModal } from '../../../modules/modal';
import { RootState } from '../../../modules';

const Profile = styled.div`
  display: flex;
`;

const ProfileImg = styled.img`
  border-radius: 4px;
  width: 36px;
  height: 36px;
  margin-right: 12px;
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

  return (
    <Container id={id}>
      <Layer onClick={() => dispatch(openModal('profile'))}>
        <Profile>
          <ProfileImg src={cookieImage}></ProfileImg>
          <ProfileNameAndStatus>
            <ProfileName>{user.name}</ProfileName>
            <ProfileStatus>
              <StatusCircle
                status={presence[user.id] || 'ONLINE'}
              ></StatusCircle>
              대화 가능
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
