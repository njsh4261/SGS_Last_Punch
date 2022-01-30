import { useState, useEffect } from 'react';
import { Owner, User } from './noteSocket';

interface HookProps {
  owner: Owner;
}

interface HookReturns {
  ownerState: User | null;
}

export default function noteOwnerHook(props: HookProps): HookReturns {
  const { owner } = props;
  const [ownerState, setOwnerState] = useState<User | null>(null);
  useEffect(() => {
    setOwnerState(owner.current);
  }, [owner.current]);
  return { ownerState };
}
