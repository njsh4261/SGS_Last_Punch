import { useEffect } from 'react';
import { Params } from 'react-router-dom';

function setTitleHook(title: string): undefined;
function setTitleHook(title: string, params: Params): undefined;

function setTitleHook(title: string, params?: Params) {
  useEffect(() => {
    if (!params) document.title = title;
    else {
      if (!params.channelId) document.title = params.wsId as string;
    }
  }, []);
}

export default setTitleHook;
