import React, { useState } from 'react';
import styled from 'styled-components';
import { useNavigate } from 'react-router-dom';
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

  @media (max-width: 880px) {
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
  const [passCheck, setPassCheck] = useState('');

  const navigate = useNavigate();

  const inputHandler = (e: React.ChangeEvent<HTMLInputElement>) => {
    if (e.target.name === 'email') setEmail(e.target.value);
    if (e.target.name === 'pass') setPass(e.target.value);
    if (e.target.name === 'passCheck') setPassCheck(e.target.value);
  };

  const submitHandler = () => {
    if (pass !== passCheck) {
      return alert('비밀번호가 서로 다릅니다');
    }
    alert('need api!');
    navigate('/');
  };

  return (
    <SignupContainer>
      <Logo></Logo>
      <GuideText>회원가입 페이지입니다</GuideText>
      <SignupBody>
        <Input value={email} inputHandler={inputHandler}></Input>
        <Input
          name="pass"
          value={pass}
          inputHandler={inputHandler}
          isPass={true}
        ></Input>
        <Input
          name="passCheck"
          value={passCheck}
          inputHandler={inputHandler}
          isPass={true}
        ></Input>
        <SubmitButton text="계속" submitHandler={submitHandler}></SubmitButton>
      </SignupBody>
    </SignupContainer>
  );
}
