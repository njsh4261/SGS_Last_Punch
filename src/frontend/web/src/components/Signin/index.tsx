import React, { useState } from 'react';
import styled from 'styled-components';
import Input from '../Common/Input';
import SubmitButton from '../Common/SubmitButton';
import DisableButton from '../Common/DisableButton';
import Logo from '../Common/Logo';
import SignUp from './SignUpButton';
import signinAPI from '../../Api/signin';

const Container = styled.article`
  width: 320px;
  & > * {
    margin-bottom: 20px;
  }
`;

export default function Signin() {
  const [email, setEmail] = useState('');
  const [pass, setPass] = useState('');

  const inputHandler = (e: React.ChangeEvent<HTMLInputElement>) => {
    if (e.target.name === 'email') setEmail(e.target.value);
    if (e.target.name === 'pass') setPass(e.target.value);
  };

  const submitHandler = async () => await signinAPI(email, pass);

  return (
    <Container>
      <Logo></Logo>
      <Input
        value={email}
        placeholder="sitama@gmail.com"
        inputHandler={inputHandler}
      ></Input>
      <Input
        name="pass"
        value={pass}
        inputHandler={inputHandler}
        placeholder="password"
        type="password"
      ></Input>
      {email !== '' && pass !== '' ? (
        <SubmitButton
          submitHandler={submitHandler}
          text="이메일로 로그인"
        ></SubmitButton>
      ) : (
        <DisableButton text="이메일로 로그인"></DisableButton>
      )}
      <SignUp></SignUp>
    </Container>
  );
}
