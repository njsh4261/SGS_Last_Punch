import { useEffect } from 'react';
import { useDispatch } from 'react-redux';

import { setUser } from '../modules/user';
import { getSelfInfoAPI } from '../Api/account';

export default function getSelfInfoHook() {
  const dispatch = useDispatch();

  const getSelf = async () => {
    const response = await getSelfInfoAPI();
    if (response) {
      if (response.account) {
        const { id, name } = response.account;
        dispatch(setUser({ id, name }));
      } else {
        console.error('fail get self');
      }
    }
  };

  useEffect(() => {
    getSelf();
  }, []);
}
