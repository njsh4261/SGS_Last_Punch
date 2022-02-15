import { useDispatch, useSelector } from 'react-redux';
import { RootState } from '../modules';

import { openModal } from '../modules/modal';

interface Props {
  type: 'channel' | 'workspace';
}

export default function ModalMenuHook({ type }: Props) {
  const disptch = useDispatch();
  const modal = useSelector((state: RootState) => state.modal);

  const openModalHandler = () => {
    disptch(openModal(type));
  };

  return { modal, openModalHandler };
}
