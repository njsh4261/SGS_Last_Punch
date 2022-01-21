import React from 'react';
import styled from 'styled-components';

interface SubmitButtonProps {
  borderRadius: string;
  fontSize: string;
  fontWeight: string;
}

const SDisableButton = styled.button<SubmitButtonProps>`
  width: 100%;
  background-color: grey;
  color: white;
  border: none;
  font-size: ${(props) => props.fontSize};
  font-weight: ${(props) => props.fontWeight};
  height: 44px;
  min-width: 96px;
  padding: 0 16px 3px;
  border-radius: ${(props) => props.borderRadius};
  &:hover {
    cursor: not-allowed;
  }
`;

interface SubmitProps {
  text: string;
  fontWeight?: string;
  fontSize?: string;
  borderRadius?: string;
}

export default function DisableButton({
  text,
  fontSize = '18px',
  fontWeight = '600',
  borderRadius = '4px',
}: SubmitProps) {
  return (
    <SDisableButton
      fontSize={fontSize}
      fontWeight={fontWeight}
      borderRadius={borderRadius}
      disabled
    >
      {text}
    </SDisableButton>
  );
}
