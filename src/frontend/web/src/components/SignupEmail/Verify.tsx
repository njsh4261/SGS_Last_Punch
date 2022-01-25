import React from 'react';
import Input from '../Common/Input';
import SubmitButton from '../Common/SubmitButton';
import DisableButton from '../Common/DisableButton';
import InputType from './input.type';

interface Props {
  input: InputType;
  inputHandler: (e: React.ChangeEvent<HTMLInputElement>) => void;
  verifyHandler: () => void;
}

export default function Verify({ input, inputHandler, verifyHandler }: Props) {
  return (
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
  );
}
