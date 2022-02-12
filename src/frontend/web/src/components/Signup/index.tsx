import React, { useState } from 'react';
import styled from 'styled-components';
import { useNavigate } from 'react-router-dom';
import Swal from 'sweetalert2';

import { signupAPI, duplicateAPI, sendAPI, verifyAPI } from '../../Api/signup';

import Logo from '../Common/Logo';
import Input from '../Common/Input';
import SubmitButton from '../Common/SubmitButton';
import DisableButton from '../Common/DisableButton';
import { RESPONSE, ERROR_MESSAGE } from '../../constant';
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
  width: 320px;
  margin: auto;
`;

export default function SignupEmailContainer() {
  const [input, setInput] = useState({
    email: '',
    code: '', // 메일로 온 인증 코드
    displayName: '', // 사용할 user name
    pass: '',
    passCheck: '', // 비밀번호 확인
  });

  const [step, setStep] = useState({
    duplicate: false, // true가 중복되지 않은 이메일
    send: false, // 인증 코드를 보내면 true로 바뀜
    verify: false, // 맞는 인증 코드를 적으면 true로 바뀜
  });

  const navigate = useNavigate();

  const inputHandler = async (e: React.ChangeEvent<HTMLInputElement>) => {
    setInput({
      ...input,
      [e.target.name]: e.target.value,
    });

    if (e.target.name === 'email') {
      // 입력된 문자열이 email 형식인지 검증
      if (isEmail(e.target.value)) {
        // 중복된 이메일인지 API로 확인
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
          if (response === undefined)
            Swal.fire(ERROR_MESSAGE.SERVER, '', 'error');
          else if (response.err) {
            if (response.err.msg === ERROR_MESSAGE.SIGNUP.DUPLICATE) {
              Swal.fire(response.err.desc, '', 'error');
            } else Swal.fire(ERROR_MESSAGE.UNKNOWN, '', 'error');
          }
        }
      } else {
        setStep({
          ...step,
          duplicate: false,
        });
      }
    }
  };

  // 이메일 인증 핸들러
  const sendHandler = async () => {
    const response = await sendAPI(input.email);
    if (response === RESPONSE.SIGNIN.SUCCESS) {
      setStep({
        ...step,
        send: true,
      });
    } else {
      Swal.fire(ERROR_MESSAGE.SERVER, '', 'error');
    }
  };

  // 인증 코드 검증 핸들러
  const verifyHandler = async () => {
    const response = await verifyAPI(input.email, input.code);
    if (response === RESPONSE.SIGNIN.SUCCESS) {
      setStep({
        ...step,
        verify: true,
      });
    } else {
      if (response === undefined) Swal.fire(ERROR_MESSAGE.SERVER, '', 'error');
      else if (response.err.msg === ERROR_MESSAGE.SIGNUP.INVALID_VERIFY_CODE) {
        Swal.fire(response.err.desc, '', 'error');
      } else Swal.fire(ERROR_MESSAGE.UNKNOWN, '', 'error');
    }
  };

  // 최종 단계에서 회원가입 버튼을 눌렀을 때의 핸들러
  const signupHandler = async () => {
    if (input.pass !== input.passCheck) {
      return Swal.fire('비밀번호가 서로 다릅니다', '', 'error');
    }
    const response = await signupAPI(
      input.email,
      input.displayName,
      input.pass,
      input.code,
    );
    if (response === RESPONSE.SIGNIN.SUCCESS) {
      Swal.fire('회원가입 성공', '', 'success');
      navigate('/signin');
    }
    if (response === undefined) Swal.fire(ERROR_MESSAGE.SERVER, '', 'error');
    else if (response.err) {
      if (response.err.msg === ERROR_MESSAGE.SIGNUP.DUPLICATE) {
        Swal.fire(response.err.desc, '', 'error');
      } else Swal.fire(ERROR_MESSAGE.UNKNOWN, '', 'error');
    }
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
