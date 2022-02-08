import React, { useState } from 'react';
import styled from 'styled-components';
import { useDispatch } from 'react-redux';
import Swal from 'sweetalert2';

import { closeModal } from '../../modules/modal';
import { inviteWsAPI } from '../../Api/workspace';
import { inviteChannelAPI } from '../../Api/channel';
import { searchMemberAPI } from '../../Api/account';
import { ModalType } from '../Main/Aside/Body/Modal';
import { useParams } from 'react-router-dom';

const Header = styled.section`
  width: 100%;
  padding: 28px 76px 20px 28px;
`;

const HeaderH1 = styled.h1`
  font-size: 28px;
  margin: 0;
`;

const Body = styled.section`
  flex: 1;
  width: 100%;
`;

const BodyLayout = styled.div`
  position: relative;
  padding: 0 28px;
`;

const Label = styled.label`
  font-weight: 700;
  padding-right: 10px;
`;

const Input = styled.input`
  width: 100%;
  border: 1px solid lightgray;
  border-radius: 4px;
  font-size: 17px;
  padding: 12px;
`;

const InputLayer = styled.article`
  margin-bottom: 20px;
  display: flex;
  align-items: center;
`;

const CandidateList = styled.article`
  position: absolute;
  overflow: scroll;
  z-index: 99;
  bottom: -50%;
  left: 20%;
  height: 80px;
  transform: translateY(75%);

  ::-webkit-scrollbar {
    -webkit-appearance: none;
    width: 10px;
  }

  ::-webkit-scrollbar-thumb {
    border-radius: 5px;
    background-color: rgba(0, 0, 0, 0.5);
  }
`;

const CandidateItem = styled.section`
  padding: 4px;
  border-bottom: 1px solid lightgray;
  width: 300px;

  :last-child {
    border-bottom: none;
  }

  :hover {
    cursor: pointer;
  }
`;

const Footer = styled.section`
  width: 100%;
  display: flex;
  align-items: center;
  justify-content: end;
  padding-right: 28px;
  margin-bottom: 28px;
`;

const Button = styled.button<{ active: boolean }>`
  border: none;
  border-radius: 4px;
  outline: none;
  cursor: ${(props) => (props.active ? 'pointer' : 'not-allowed')};
  background-color: ${(props) => (props.active ? '#007A5A' : '#DDDDDD')};
  width: 56px;
  height: 35px;
  padding: 0 12px 1px;
  color: white;
`;
export default function InviteModal({
  wsId,
  type,
}: {
  wsId: string;
  type: ModalType;
}) {
  const [candidates, setCandidates] = useState([]);
  const [selectedUser, selectUser] = useState();
  const [inviteEmail, setInviteEmail] = useState('');
  const params = useParams();
  const dispatch = useDispatch();

  const searchHandler = async (e: React.ChangeEvent<HTMLInputElement>) => {
    setInviteEmail(e.target.value);
    const members = await searchMemberAPI(e.target.value);
    if (members) {
      setCandidates(members);
    }
  };

  const inviteHandler = async () => {
    if (selectedUser) {
      let response;
      switch (type) {
        case 'invite-workspace':
          response = await inviteWsAPI(+wsId, +(selectedUser as any).id);
          if (response?.err) {
            Swal.fire(response.err.desc, '', 'error');
          }
          break;
        case 'invite-channel':
          response = await inviteChannelAPI(
            +(selectedUser as any).id,
            +params.channelId!,
            1,
          );
          if (response?.err) {
            Swal.fire(response.err.desc, '', 'error');
          }
          break;
      }
      if (response) {
        dispatch(closeModal());
      }
    }
  };

  const selectHandler = (e: React.MouseEvent<HTMLDivElement>) => {
    const { target }: { target: any } = e;
    const user = JSON.parse(target.dataset.info);
    selectUser(user);
    setInviteEmail(user.email);
  };

  return (
    <>
      <Header>
        <HeaderH1>{type}</HeaderH1>
      </Header>
      <Body>
        <BodyLayout>
          <InputLayer>
            <Label>받는 사람</Label>
            <Input
              name="inviteEmail"
              placeholder="name@gmail.com"
              value={inviteEmail}
              onChange={searchHandler}
            ></Input>
          </InputLayer>
          <CandidateList>
            {candidates.map((candidate: any) => (
              <CandidateItem
                key={candidate.id}
                data-info={JSON.stringify(candidate)}
                onClick={selectHandler}
              >
                {candidate.name}({candidate.email})
              </CandidateItem>
            ))}
          </CandidateList>
        </BodyLayout>
      </Body>
      <Footer>
        <Button active={inviteEmail !== ''} onClick={inviteHandler}>
          보내기
        </Button>
      </Footer>
    </>
  );
}
