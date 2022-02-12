import React from 'react';
import Input from '../Common/Input';
import SubmitButton from '../Common/SubmitButton';
import DisableButton from '../Common/DisableButton';
import InputType from '../../../types/signupInput.type';

interface Props {
  input: InputType;
  inputHandler: (e: React.ChangeEvent<HTMLInputElement>) => void;
  signupHandler: () => void;
}

export default function Pass({ input, inputHandler, signupHandler }: Props) {
  return (
    <>
      <Input
        name="displayName"
        value={input.displayName}
        inputHandler={inputHandler}
        placeholder="display name"
      ></Input>
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
      {input.email !== '' && input.pass !== '' && input.passCheck !== '' ? (
        <SubmitButton text="계속" submitHandler={signupHandler}></SubmitButton>
      ) : (
        <DisableButton text="계속"></DisableButton>
      )}
    </>
  );
}
