import { combineReducers } from 'redux';
import { all } from 'redux-saga/effects';
import modal from './modal';
import channel, { channelSaga } from './channel';
import work, { workSaga } from './worksapce';
import user from './user';
import channelList from './channeList';
import userList from './userList';

const rootReducer = combineReducers({
  modal,
  channel,
  work,
  user,
  channelList,
  userList,
});

export default rootReducer;

export function* rootSaga() {
  yield all([channelSaga(), workSaga()]);
}

export type RootState = ReturnType<typeof rootReducer>;
