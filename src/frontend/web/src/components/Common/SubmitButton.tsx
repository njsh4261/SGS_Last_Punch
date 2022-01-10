import React from 'react';
import styled from 'styled-components';

const SsubmitButton = styled.button`
  width: 100%;
  background-color: #4a154b;
  color: white;
  border: none;
  font-size: 18px;
  font-weight: 600;
  height: 44px;
  min-width: 96px;
  padding: 0 16px 3px;
  &:hover {
    cursor: pointer;
  }
`;

interface SubmitProps {
  text: string;
  submitHandler: (e: React.MouseEvent<HTMLButtonElement>) => void;
}

export default function SubmitButton({ text, submitHandler }: SubmitProps) {
  return <SsubmitButton onClick={submitHandler}>{text}</SsubmitButton>;
}
