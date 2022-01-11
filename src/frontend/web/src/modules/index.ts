import { combineReducers } from 'redux';
import { all } from 'redux-saga/effects';
import modal from './modal';

const rootReducer = combineReducers({ modal });

export default rootReducer;

export function* rootSaga() {
  yield all([]);
}

export type RootState = ReturnType<typeof rootReducer>;
