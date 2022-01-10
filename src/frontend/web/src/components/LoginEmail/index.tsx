import React, { useState } from 'react';
import styled from 'styled-components';
import Input from '../Common/Input';
import SubmitButton from '../Common/SubmitButton';
import Logo from '../Common/Logo';
import SignUp from './SignUp';

const LoginContainer = styled.article`
  width: 420px;
  & > * {
    margin-bottom: 20px;
  }
`;

export default function LoginEmailContainer() {
  const [email, setEmail] = useState('');
  const [pass, setPass] = useState('');

  const inputHandler = (e: React.ChangeEvent<HTMLInputElement>) => {
    if (e.target.name === 'email') setEmail(e.target.value);
    if (e.target.name === 'pass') setPass(e.target.value);
  };

  const submitHandler = () => {
    alert('need api!');
  };

  return (
    <LoginContainer>
      <Logo></Logo>
      <Input value={email} inputHandler={inputHandler}></Input>
      <Input value={pass} inputHandler={inputHandler} isPass={true}></Input>
      <SubmitButton
        submitHandler={submitHandler}
        text="이메일로 로그인"
      ></SubmitButton>
      <SignUp></SignUp>
    </LoginContainer>
  );
}
