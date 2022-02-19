import React, { useState } from 'react';
import styled from 'styled-components';

import ModalBox from '../../Common/ModalBox';
import { UserStatus } from '../../../../types/presence';
import StatusCircle from '../../Common/StatusCircle';
import { useDispatch, useSelector } from 'react-redux';
import { closeModal } from '../../../modules/modal';
import { RootState } from '../../../modules';

const Header = styled.header`
  width: 100%;
  padding: 28px 76px 20px 28px;
  font-size: 22px;
  font-weight: bold;
`;

const Body = styled.main``;

const StatusNow = styled.article`
  display: flex;
  align-items: center;
  padding: 10px 28px;
`;

const StatusItem = styled.section`
  display: flex;
  align-items: center;
  padding: 10px 28px;
  :last-child {
    margin-bottom: 20px;
  }
  & > * {
    margin-right: 6px;
  }
  :hover {
    background-color: lightgray;
  }
`;

const Footer = styled.footer`
  display: flex;
  justify-content: end;
  margin: 10px 10px;
`;

const Button = styled.button`
  border: none;
  border-radius: 4px;
  outline: none;
  cursor: pointer;
  background-color: #007a5a;
  width: 56px;
  height: 35px;
  padding: 0 12px 1px;
  color: white;
`;

interface Props {
  sendMessage: (userStatus: UserStatus) => void;
}

export default function ModalStatus({ sendMessage }: Props) {
  const dispatch = useDispatch();
  const user = useSelector((state: RootState) => state.user);
  const presence = useSelector((state: RootState) => state.presence);
  const [statusState, setStatusState] = useState<UserStatus>(
    presence[user.id] || 'ONLINE',
  );
  const statusList: UserStatus[] = ['ONLINE', 'BUSY', 'ABSENT', 'OFFLINE'];

  const changeHandler = (status: UserStatus) => () => {
    setStatusState(status);
  };

  const submitHandler = () => {
    sendMessage(statusState);
    dispatch(closeModal());
  };

  return (
    <ModalBox width="320px">
      <Header>상태 설정</Header>
      <Body>
        <StatusNow>
          현재상태: <StatusCircle status={statusState}></StatusCircle>
        </StatusNow>
        <article>
          {statusList.map((status) => (
            <StatusItem key={status} onClick={changeHandler(status)}>
              <StatusCircle status={status}></StatusCircle>
              {status}
            </StatusItem>
          ))}
        </article>
      </Body>
      <Footer>
        <Button onClick={submitHandler}>저장</Button>
      </Footer>
    </ModalBox>
  );
}
