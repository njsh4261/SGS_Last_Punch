import React from 'react';
import styled from 'styled-components';

interface SubmitButtonProps {
  borderRadius: string;
  light: boolean;
  fontSize: string;
  fontWeight: string;
}

const SsubmitButton = styled.button<SubmitButtonProps>`
  width: 100%;
  background-color: ${({ light, theme }) =>
    light ? theme.color.lightSlack : theme.color.slack};
  color: white;
  border: none;
  font-size: ${(props) => props.fontSize};
  font-weight: ${(props) => props.fontWeight};
  height: 44px;
  min-width: 96px;
  padding: 0 16px 3px;
  border-radius: ${(props) => props.borderRadius};
  &:hover {
    cursor: pointer;
  }
`;

interface SubmitProps {
  text: string;
  fontWeight?: string;
  fontSize?: string;
  borderRadius?: string;
  light?: boolean;
  submitHandler: (e: React.MouseEvent<HTMLButtonElement>) => void;
}

export default function SubmitButton({
  text,
  submitHandler,
  fontSize = '18px',
  fontWeight = '600',
  borderRadius = '4px',
  light = false,
}: SubmitProps) {
  return (
    <SsubmitButton
      fontSize={fontSize}
      fontWeight={fontWeight}
      borderRadius={borderRadius}
      light={light}
      onClick={submitHandler}
    >
      {text}
    </SsubmitButton>
  );
}
