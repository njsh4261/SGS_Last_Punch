import React from 'react';
import styled from 'styled-components';
import { useDispatch } from 'react-redux';
import { closeModal } from '../../modules/modal';

const ModalController = styled.label`
  position: fixed;
  top: 0;
  bottom: 0;
  left: 0;
  right: 0;
`;

const ModalState = styled.input`
  display: none;
`;
const ModalView = styled.div`
  ${ModalState}+ & {
    display: flex;
    background-color: black;
    opacity: 60%;
    width: 100%;
    height: 100%;
  }
  ${ModalState}:checked + & {
    display: none;
  }
`;

export default function ModalWrapper({ active }: { active: boolean }) {
  const dispatch = useDispatch();
  const closeHandler = () => dispatch(closeModal());

  return (
    <ModalController>
      <ModalState type="checkbox" checked={!active} onChange={closeHandler} />
      <ModalView></ModalView>
    </ModalController>
  );
}
