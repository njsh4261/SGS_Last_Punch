import { NavigateFunction } from 'react-router-dom';
import { call, put, takeLeading } from 'redux-saga/effects';

const SELECT_WORK = 'workspace/select';
const SELECT_WORK_SUCCESS = 'workspace/success';
const SELECT_WORK_FAILURE = 'workspace/failure';

type WorkState = {
  id: string;
  name: string;
  loading: boolean;
  error: boolean;
};

export const selectWork = (id: string, navigate: NavigateFunction) => ({
  type: SELECT_WORK,
  id,
  name: '',
  navigate,
});

type WorkAction = ReturnType<typeof selectWork>;

const initWorkState: WorkState = {
  id: 'workInit1',
  name: 'default workspace',
  loading: false,
  error: false,
};

function* selectWorkSaga(action: WorkAction) {
  // dummy api
  const dummyApi = (id: string): Promise<{ id: string; name: string }> => {
    return new Promise((res) => {
      setTimeout(() => {
        res({
          id,
          name: `workspace id: ${id}`,
        });
      }, 100);
    });
  };
  try {
    const work: WorkAction = yield call(dummyApi, action.id);
    yield put({
      type: SELECT_WORK_SUCCESS,
      id: work.id,
      name: work.name,
    });
    action.navigate(work.id);
  } catch (e) {
    yield put({
      type: SELECT_WORK_FAILURE,
    });
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
