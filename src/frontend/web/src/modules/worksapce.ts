import { NavigateFunction } from 'react-router-dom';
import { put, takeLeading } from 'redux-saga/effects';

const SELECT_WORK = 'workspace/select';
const SELECT_WORK_SUCCESS = 'workspace/success';
const SELECT_WORK_FAILURE = 'workspace/failure';

type WorkState = {
  id: number;
  name: string;
  loading: boolean;
  error: boolean;
};

export const selectWork = (
  id: number,
  name: string,
  navigate: NavigateFunction,
) => ({
  type: SELECT_WORK,
  id,
  name,
  navigate,
});

type WorkAction = ReturnType<typeof selectWork>;

const initWorkState: WorkState = {
  id: 1351,
  name: 'default workspace',
  loading: false,
  error: false,
};

function* selectWorkSaga(action: WorkAction) {
  try {
    yield put({
      type: SELECT_WORK_SUCCESS,
      id: action.id,
      name: action.name,
    });
    action.navigate('/' + action.id.toString());
  } catch (e) {
    console.error(e);
    yield put({
      type: SELECT_WORK_FAILURE,
    });
    alert('error!');
  }
}

export function* workSaga() {
  yield takeLeading(SELECT_WORK, selectWorkSaga);
}

export default function work(
  state: WorkState = initWorkState,
  action: WorkAction,
): WorkState {
  switch (action.type) {
    case SELECT_WORK:
      return {
        ...state,
        loading: true,
      };
    case SELECT_WORK_SUCCESS:
      return {
        id: action.id,
        name: action.name,
        loading: false,
        error: false,
      };
    case SELECT_WORK_FAILURE:
      return {
        ...state,
        loading: false,
        error: true,
      };
    default:
      return state;
  }
}
