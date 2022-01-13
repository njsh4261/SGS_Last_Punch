import React, { useState } from 'react';
import styled from 'styled-components';
import { useNavigate } from 'react-router-dom';
import Input from '../Common/Input';
import SubmitButton from '../Common/SubmitButton';
import Logo from '../Common/Logo';
import SignUp from './SignUp';
import loginAPI from '../../Api/login';

const LoginContainer = styled.article`
  width: 420px;
  & > * {
    margin-bottom: 20px;
  }
`;

export default function LoginEmailContainer() {
  const [email, setEmail] = useState('');
  const [pass, setPass] = useState('');

  const navigate = useNavigate();

  const inputHandler = (e: React.ChangeEvent<HTMLInputElement>) => {
    if (e.target.name === 'email') setEmail(e.target.value);
    if (e.target.name === 'pass') setPass(e.target.value);
  };

  const submitHandler = async () => {
    const data = await loginAPI(email, pass);

    //// 임시코드 -> 나중에 삭제 필요!!!!!
    sessionStorage.setItem('jwt', 'dump');
    navigate('/');
    ////// 나중에 반드시 삭제!!!!!

    if (data) {
      const { accessToken, refreshToken } = data;
      sessionStorage.setItem(accessToken, refreshToken);
      navigate('/');
    } else {
      alert('로그인 실패');
    }
  };

  return (
    <LoginContainer>
      <Logo></Logo>
      <Input value={email} inputHandler={inputHandler}></Input>
      <Input
        name="pass"
        value={pass}
        inputHandler={inputHandler}
        isPass={true}
      ></Input>
      <SubmitButton
        submitHandler={submitHandler}
        text="이메일로 로그인"
      ></SubmitButton>
      <SignUp></SignUp>
    </LoginContainer>
  );
}
