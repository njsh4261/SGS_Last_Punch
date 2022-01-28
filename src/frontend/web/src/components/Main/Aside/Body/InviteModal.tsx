import React, { useState } from 'react';
import styled from 'styled-components';

import { inviteWsAPI } from '../../../../Api/workspace';

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
  padding: 0 28px;
`;

const Label = styled.label`
  font-weight: 700;
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
  ${Label} + ${Input} {
    margin-top: 10px;
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
export default function InviteModal() {
  const [inviteEmail, setInviteEmail] = useState('');
  const inviteHandler = (e: React.ChangeEvent<HTMLInputElement>) => {
    setInviteEmail(e.target.value);
    // todo: 사용자 검색 api
  };

  const submitHandler = () => {
    // call api: inviteWsAPI(targetId)
    alert('need api');
  };

  return (
    <>
      <Header>
        <HeaderH1>이 워크스페이스로 사용자 초대</HeaderH1>
      </Header>
      <Body>
        <BodyLayout>
          <InputLayer>
            <Label>받는 사람</Label>
            <Input
              name="inviteEmail"
              placeholder="name@gmail.com"
              value={inviteEmail}
              onChange={inviteHandler}
            ></Input>
          </InputLayer>
        </BodyLayout>
      </Body>
      <Footer>
        <Button active={inviteEmail !== ''} onClick={submitHandler}>
          보내기
        </Button>
      </Footer>
    </>
  );
}
