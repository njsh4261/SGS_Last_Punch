import { UserStatus } from '../../types/presence';

const SET_PRESENCE = 'presence/set';

export type PresenceState = {
  [index: string]: UserStatus;
};

export const setPresence = (presenceDictionary: PresenceState) => ({
  type: SET_PRESENCE,
  presenceDictionary,
});

type PresenceAction = ReturnType<typeof setPresence>;

const initialPresence = {
  0: 'OFFINE',
};

export default function presence(
  state = initialPresence,
  action: PresenceAction,
) {
  switch (action.type) {
    case SET_PRESENCE:
      return { ...action.presenceDictionary };
    default:
      return state;
  }
}
