const OPEN_MODAL = 'modal/open';
const CLOSE_MODAL = 'modal/close';

export const openModal = () => ({
  type: OPEN_MODAL,
});
export const closeModal = () => ({
  type: CLOSE_MODAL,
});

type ModalAction = ReturnType<typeof openModal> | ReturnType<typeof closeModal>;

type ModalState = {
  active: boolean;
};

const initModalState: ModalState = {
  active: false,
};

function modal(
  state: ModalState = initModalState,
  action: ModalAction,
): ModalState {
  switch (action.type) {
    case OPEN_MODAL:
      return { active: true };
    case CLOSE_MODAL:
      return { active: false };
    default:
      return state;
  }
}

export default modal;
