import { call, put, takeLeading } from 'redux-saga/effects';
import { getWsInfoAPI } from '../Api/workspace';

const SELECT_WORK = 'workspace/select';
const SELECT_WORK_SUCCESS = 'workspace/success';
const SELECT_WORK_FAILURE = 'workspace/failure';

type WorkState = {
  id: number;
  name: string;
  loading: boolean;
  error: boolean;
};

export const selectWork = (id: number, name = '') => ({
  type: SELECT_WORK,
  id,
  name,
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
    const { workspace }: { workspace: WorkAction } = yield call(
      getWsInfoAPI,
      action.id,
    );
    yield put({
      type: SELECT_WORK_SUCCESS,
      id: workspace.id,
      name: workspace.name,
    });
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
