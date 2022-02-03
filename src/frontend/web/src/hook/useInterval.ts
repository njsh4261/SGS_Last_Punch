import { useEffect, useRef } from 'react';

export default function useInterval(callback: any, delay: number) {
  const savedCallback = useRef<() => any>(); // 최근에 들어온 callback을 저장할 ref를 하나 만든다.

  useEffect(() => {
    savedCallback.current = callback; // callback이 바뀔 때마다 ref를 업데이트 해준다.
  }, [callback]);

  useEffect(() => {
    function tick() {
      try {
        savedCallback.current!(); // tick이 실행되면 callback 함수를 실행시킨다.
      } catch (e) {
        console.error('useInterval Error.', e);
      }
    }
    if (delay !== null) {
      // 만약 delay가 null이 아니라면
      const id = setInterval(tick, delay); // delay에 맞추어 interval을 새로 실행시킨다.
      return () => clearInterval(id); // unmount될 때 clearInterval을 해준다.
    }
  }, [delay]); // delay가 바뀔 때마다 새로 실행된다.
}
