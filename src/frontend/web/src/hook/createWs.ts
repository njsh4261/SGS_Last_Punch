import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import Swal from 'sweetalert2';

import { createWsAPI } from '../Api/workspace';
import { ERROR_MESSAGE } from '../constant';

export default function createWsHook(): [
  wsName: string,
  channelName: string,
  inputHandler: (e: React.ChangeEvent<HTMLInputElement>) => void,
  step: number,
  nextStepHandler: () => Promise<void>,
] {
  const [wsName, setWsName] = useState('새 워크스페이스');
  const [channelName, setChannelName] = useState('');
  const [step, setStep] = useState(1);

  const navigate = useNavigate();

  // 개설 단계에 따른 핸들링
  const nextStepHandler = async () => {
    if (step + 1 === 3) {
      if (channelName === '') {
        Swal.fire('팀이 사용할 채널 명을 입력하세요', '', 'info');
        return;
      }
      const response = await createWsAPI(wsName, channelName);
      if (response === undefined) {
        Swal.fire(ERROR_MESSAGE.SERVER, '', 'error');
        navigate('/');
      } else {
        Swal.fire('워크스페이스가 생성됐어요 :)', '', 'success');
        navigate('/');
      }
      return;
    }
    setStep((state) => state + 1);
  };

  const inputHandler = (e: React.ChangeEvent<HTMLInputElement>) => {
    if (e.target.name === 'ws') setWsName(e.target.value);
    if (e.target.name === 'channel') setChannelName(e.target.value);
  };

  return [wsName, channelName, inputHandler, step, nextStepHandler];
}
