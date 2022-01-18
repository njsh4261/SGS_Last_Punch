import { combineReducers } from 'redux';
import { all } from 'redux-saga/effects';
import modal from './modal';
import channel, { channelSaga } from './channel';
import work, { workSaga } from './worksapce';

const rootReducer = combineReducers({ modal, channel, work });

export default rootReducer;

export function* rootSaga() {
  yield all([channelSaga(), workSaga()]);
}

export type RootState = ReturnType<typeof rootReducer>;
