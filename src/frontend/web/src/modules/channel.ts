import { NavigateFunction } from 'react-router-dom';
import { takeLeading, call, put } from 'redux-saga/effects';
import { getChannelInfoAPI } from '../Api/channel';

const SELECT_CAHNNEL = 'channel/select';
const SELECT_CHANNEL_SUCCESS = 'channel/success';
const SELECT_CHANNEL_FAILURE = 'channel/failure';

type ChannelState = {
  id: string;
  name: string;
  loading: boolean;
  error: boolean;
};

export const selectChannel = (
  id: string,
  name = '',
  // navigate: NavigateFunction,
) => ({
  type: SELECT_CAHNNEL,
  id,
  name,
  // navigate,
});

type ChannelAction = ReturnType<typeof selectChannel>;

const initChannelState: ChannelState = {
  id: '',
  name: 'default name',
  loading: false,
  error: false,
};

type ChannelInfo = {
  id: number;
  name: string;
  workspaceId: number;
  creator: any;
  topic: string;
  status: number;
  settings: number;
};

function* selectChannelSaga(action: ChannelAction) {
  try {
    const { channel }: { channel: ChannelInfo } = yield call(
      getChannelInfoAPI,
      action.id,
    );
    yield put({
      type: SELECT_CHANNEL_SUCCESS,
      id: channel.id,
      name: channel.name,
    });
    // action.navigate('../' + channel.id, {
    //   state: { channelName: channel.name },
    // });
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
