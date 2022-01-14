import { combineReducers } from 'redux';
import { all } from 'redux-saga/effects';
import modal from './modal';
import channel, { channelSaga } from './channel';

const rootReducer = combineReducers({ modal, channel });

export default rootReducer;

export function* rootSaga() {
  yield all([channelSaga()]);
}

export type RootState = ReturnType<typeof rootReducer>;
