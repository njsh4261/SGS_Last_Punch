import React from 'react';
import styled from 'styled-components';

const Sinput = styled.input`
  padding: 11px 12px 13px;
  height: 44px;
  font-size: 18px;
  line-height: 1.333333;
  border-radius: 4px;
  border: 1px solid rgba(29, 28, 29, 0.3);
  width: 100%;
`;

interface InputProps {
  isPass?: boolean;
  name?: string;
  value: string;
  inputHandler: (e: React.ChangeEvent<HTMLInputElement>) => void;
}

export default function Input({
  isPass = false,
  value,
  inputHandler,
  name = 'email',
}: InputProps) {
  return (
    <Sinput
      name={name}
      value={value}
      onChange={inputHandler}
      type={isPass ? 'password' : 'text'}
      placeholder={isPass ? 'password' : 'name@work-email.com'}
    ></Sinput>
  );
}
