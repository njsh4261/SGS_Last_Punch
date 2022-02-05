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
  outline: none;
  box-shadow: 1px 1px 2px darkgray;
`;

interface InputProps {
  type?: 'text' | 'password';
  name?: string;
  value: string;
  placeholder?: string;
  inputHandler: (e: React.ChangeEvent<HTMLInputElement>) => void;
  disabled?: boolean;
}

export default function Input({
  type = 'text',
  value,
  inputHandler,
  name = 'email',
  placeholder,
  disabled = false,
}: InputProps) {
  return (
    <Sinput
      name={name}
      value={value}
      onChange={inputHandler}
      type={type}
      placeholder={placeholder}
      disabled={disabled}
      autoComplete="off"
    ></Sinput>
  );
}
