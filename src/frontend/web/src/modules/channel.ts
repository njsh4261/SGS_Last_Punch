import { takeLeading, call, put } from 'redux-saga/effects';

const SELECT_CAHNNEL = 'channel/select';
const SELECT_CHANNEL_SUCCESS = 'channel/success';
const SELECT_CHANNEL_FAILURE = 'channel/failure';

type ChannelState = {
  id: string;
  name: string;
  loading: boolean;
  error: boolean;
};

export const selectChannel = (id: string) => ({
  type: SELECT_CAHNNEL,
  id,
  name: '',
});

type ChannelAction = ReturnType<typeof selectChannel>;

const initChannelState: ChannelState = {
  id: '',
  name: 'default name',
  loading: false,
  error: false,
};

function* selectChannelSaga(action: ChannelAction) {
  // dummy api
  const dummyApi = (id: string): Promise<{ id: string; name: string }> => {
    return new Promise((res) => {
      setTimeout(() => {
        res({
          id,
          name: `채널 아이디 ${id}`,
        });
      }, 500);
    });
  };
  try {
    const channel: ChannelAction = yield call(dummyApi, action.id);
    yield put({
      type: SELECT_CHANNEL_SUCCESS,
      id: channel.id,
      name: channel.name,
    });
  } catch (e) {
    yield put({
      type: SELECT_CHANNEL_FAILURE,
    });
  }
}

export function* channelSaga() {
  yield takeLeading(SELECT_CAHNNEL, selectChannelSaga);
}

export default function channel(
  state: ChannelState = initChannelState,
  action: ChannelAction,
): ChannelState {
  switch (action.type) {
    case SELECT_CAHNNEL:
      return {
        ...state,
        loading: true,
      };
    case SELECT_CHANNEL_SUCCESS:
      return {
        id: action.id,
        name: action.name,
        loading: false,
        error: false,
      };
    case SELECT_CHANNEL_FAILURE:
      return {
        ...state,
        loading: false,
        error: true,
      };
    default:
      return state;
  }
}
