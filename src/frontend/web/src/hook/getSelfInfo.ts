import { useEffect } from 'react';
import { useDispatch } from 'react-redux';

import { setUser } from '../modules/user';
import { getSelfInfoAPI } from '../Api/account';

/** 내 유저 정보를 가져온다
 */
export default function getSelfInfoHook() {
  const dispatch = useDispatch();

  const getSelf = async () => {
    const response = await getSelfInfoAPI();
    if (response) {
      if (response.account) {
        const { id, name, imageNum } = response.account;
        dispatch(setUser({ id, name, imageNum }));
      } else {
        console.error('fail get self');
      }
    }
  };

  useEffect(() => {
    getSelf();
  }, []);
}
