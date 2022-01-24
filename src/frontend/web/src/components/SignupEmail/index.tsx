import React, { useState } from 'react';
import styled from 'styled-components';
import { useNavigate } from 'react-router-dom';
import Logo from '../Common/Logo';
import Input from '../Common/Input';
import SubmitButton from '../Common/SubmitButton';
import DisableButton from '../Common/DisableButton';
import { signupAPI, duplicateAPI, sendAPI, verifyAPI } from '../../Api/signup';
import { RESPONSE } from '../../constant';
import Pass from './Pass';
import Verify from './Verify';
import isEmail from '../../util/isEmail';

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
  const [input, setInput] = useState({
    email: '',
    code: '',
    pass: '',
    passCheck: '',
  });

  const [step, setStep] = useState({
    duplicate: false,
    send: false,
    verify: false,
  });

  const navigate = useNavigate();

  const inputHandler = async (e: React.ChangeEvent<HTMLInputElement>) => {
    setInput({
      ...input,
      [e.target.name]: e.target.value,
    });

    if (e.target.name === 'email') {
      if (isEmail(e.target.value)) {
        const response = await duplicateAPI(e.target.value);
        if (response === RESPONSE.SIGNIN.SUCCESS) {
          setStep({
            ...step,
            duplicate: true,
          });
        } else {
          setStep({
            ...step,
            duplicate: false,
          });
        }
      }
    }
  };

  const sendHandler = async () => {
    const response = await sendAPI(input.email);
    if (response === RESPONSE.SIGNIN.SUCCESS) {
      setStep({
        ...step,
        send: true,
      });
    } else {
      alert('fail');
      navigate('/signup');
    }
  };

  const verifyHandler = async () => {
    const response = await verifyAPI(input.email, input.code);
    if (response) {
      setStep({
        ...step,
        verify: true,
      });
    }
  };

  const signupHandler = async () => {
    if (input.pass !== input.passCheck) {
      return alert('비밀번호가 서로 다릅니다');
    }
    const success = await signupAPI(input.email, input.pass, input.code);

    if (!success) alert('회원가입 실패');
    else alert('회원가입 성공');
    navigate('/login');
  };

  return (
    <SignupContainer>
      <Logo></Logo>
      <GuideText>회원가입 페이지입니다</GuideText>
      <SignupBody>
        <Input
          value={input.email}
          inputHandler={inputHandler}
          placeholder="your@email.com"
          disabled={step.send}
        ></Input>

        {step.verify ? (
          <Pass
            input={input}
            inputHandler={inputHandler}
            signupHandler={signupHandler}
          ></Pass>
        ) : (
          <>
            {step.send ? (
              <Verify
                input={input}
                inputHandler={inputHandler}
                verifyHandler={verifyHandler}
              ></Verify>
            ) : (
              <>
                {step.duplicate ? (
                  <SubmitButton
                    text="SEND"
                    submitHandler={sendHandler}
                  ></SubmitButton>
                ) : (
                  <DisableButton text="SEND"></DisableButton>
                )}
              </>
            )}
          </>
        )}
      </SignupBody>
    </SignupContainer>
  );
}
