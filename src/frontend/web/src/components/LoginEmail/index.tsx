import React, { useState } from 'react';
import styled from 'styled-components';
import Input from '../Common/Input';
import SubmitButton from '../Common/SubmitButton';
import Logo from './Logo';
import SignUp from './SignUp';

const InputContainer = styled.article`
  width: 420px;
`;

const MarginBottom20 = styled.section`
  margin-bottom: 20px;
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
    <InputContainer>
      <MarginBottom20>
        <Logo></Logo>
      </MarginBottom20>
      <MarginBottom20>
        <Input value={email} inputHandler={inputHandler}></Input>
      </MarginBottom20>
      <MarginBottom20>
        <Input value={pass} inputHandler={inputHandler} isPass={true}></Input>
      </MarginBottom20>
      <MarginBottom20>
        <SubmitButton
          submitHandler={submitHandler}
          text="이메일로 로그인"
        ></SubmitButton>
      </MarginBottom20>
      <SignUp></SignUp>
    </InputContainer>
  );
}
