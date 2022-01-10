import React, { useState } from 'react';
import styled from 'styled-components';
import Logo from '../Common/Logo';
import Input from '../Common/Input';
import SubmitButton from '../Common/SubmitButton';

const SignupContainer = styled.article`
  & * {
    margin-bottom: 20px;
  }
`;

const GuideText = styled.header`
  font-weight: 700;
  font-size: 48px;
  max-width: 700px;
  text-align: center;

  @media (max-width: 1200px) {
    font-size: 32px;
  }
`;

const SignupBody = styled.main`
  width: 420px;
  margin: auto;
`;

export default function SignupEmailContainer() {
  const [email, setEmail] = useState('');
  const [pass, setPass] = useState('');

  const inputHandler = (e: React.ChangeEvent<HTMLInputElement>) => {
    if (e.target.name === 'email') setEmail(e.target.value);
    if (e.target.name === 'pass') setPass(e.target.value);
  };

  const submitHandler = () => alert('need api!');

  return (
    <SignupContainer>
      <Logo></Logo>
      <GuideText>먼저 이메일부터 입력해 보세요</GuideText>
      <SignupBody>
        <Input value={email} inputHandler={inputHandler}></Input>
        <SubmitButton text="계속" submitHandler={submitHandler}></SubmitButton>
      </SignupBody>
    </SignupContainer>
  );
}
