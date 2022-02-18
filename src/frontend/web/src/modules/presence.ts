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

const initialPresence: PresenceState = {};

export default function presence(
  state = initialPresence,
  action: PresenceAction,
): PresenceState {
  switch (action.type) {
    case SET_PRESENCE:
      return { ...action.presenceDictionary };
    default:
      return state;
  }
}
