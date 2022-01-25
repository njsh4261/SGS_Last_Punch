import { useState } from 'react';
import { useDispatch } from 'react-redux';
import { useParams } from 'react-router-dom';

import { closeModal } from '../modules/modal';
import { createChannelAPI } from '../Api/channel';

export default function createChannelHook(): [
  channelName: string,
  description: string,
  inputHandler: (e: React.ChangeEvent<HTMLInputElement>) => void,
  submitHandler: () => void,
] {
  const dispatch = useDispatch();
  const params = useParams();
  const [channelName, setChannelName] = useState('');
  const [description, setDescription] = useState('');

  const inputHandler = (e: React.ChangeEvent<HTMLInputElement>) => {
    if (e.target.name === 'channelName') setChannelName(e.target.value);
    if (e.target.name === 'description') setDescription(e.target.value);
  };

  const submitHandler = async () => {
    if (channelName === '') return;
    const success = await createChannelAPI({
      workspaceId: Number(params.wsId),
      name: channelName,
      description,
    });
    if (success) {
      dispatch(closeModal());
    } else {
      alert('채널 생성 실패');
      dispatch(closeModal());
    }
  };

  return [channelName, description, inputHandler, submitHandler];
}
