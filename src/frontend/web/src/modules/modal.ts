import { ModalType } from '../components/Main/Aside/Body/Modal';

const OPEN_MODAL = 'modal/open';
const CLOSE_MODAL = 'modal/close';

export const openModal = (modalType: ModalType) => ({
  type: OPEN_MODAL,
  modalType,
});
export const closeModal = () => ({
  type: CLOSE_MODAL,
});

type ModalAction = ReturnType<typeof openModal>;

type ModalState = {
  active: boolean;
  modalType: ModalType;
};

const initModalState: ModalState = {
  active: false,
  modalType: 'channel',
};

function modal(
  state: ModalState = initModalState,
  action: ModalAction,
): ModalState {
  switch (action.type) {
    case OPEN_MODAL:
      return { active: true, modalType: action.modalType };
    case CLOSE_MODAL:
      return { ...state, active: false };
    default:
      return state;
  }
}

export default modal;
