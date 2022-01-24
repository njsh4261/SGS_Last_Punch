import React, { useState } from 'react';
import styled from 'styled-components';
import { useNavigate } from 'react-router-dom';
import Logo from '../Common/Logo';
import Input from '../Common/Input';
import SubmitButton from '../Common/SubmitButton';
import DisableButton from '../Common/DisableButton';
import signupAPI from '../../Api/signup';

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

  const inputHandler = (e: React.ChangeEvent<HTMLInputElement>) => {
    setInput({
      ...input,
      [e.target.name]: e.target.value,
    });
    // call duplicate api
    setStep({
      ...step,
      duplicate: true,
    });
  };

  const sendHandler = () => {
    // call send email api
    setStep({
      ...step,
      send: true,
    });
  };

  const verifyHandler = () => {
    setStep({
      ...step,
      verify: true,
    });
  };

  const signupHandler = async () => {
    if (input.pass !== input.passCheck) {
      return alert('비밀번호가 서로 다릅니다');
    }
    const success = await signupAPI(input.email, input.pass);

    if (success) navigate('/login');
    else alert('회원가입 실패');

    // 임시코드 -> 나중에 삭제!!
    navigate('/login');
    // 나중에 반드시 삭제!!!
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
          <>
            <Input
              name="pass"
              value={input.pass}
              inputHandler={inputHandler}
              type="password"
              placeholder="password"
            ></Input>
            <Input
              name="passCheck"
              value={input.passCheck}
              inputHandler={inputHandler}
              type="password"
              placeholder="check password"
            ></Input>
            {input.email !== '' &&
            input.pass !== '' &&
            input.passCheck !== '' ? (
              <SubmitButton
                text="계속"
                submitHandler={signupHandler}
              ></SubmitButton>
            ) : (
              <DisableButton text="계속"></DisableButton>
            )}
          </>
        ) : (
          <>
            {step.send ? (
              <>
                <Input
                  value={input.code}
                  name="code"
                  inputHandler={inputHandler}
                  placeholder="code"
                ></Input>
                {input.code !== '' ? (
                  <SubmitButton
                    text="Verify"
                    submitHandler={verifyHandler}
                  ></SubmitButton>
                ) : (
                  <DisableButton text="Verify"></DisableButton>
                )}
              </>
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
