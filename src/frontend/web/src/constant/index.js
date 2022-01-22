export const HOST = process.env.REACT_APP_BACKEND_HOST;

export const ERROR_MESSAGE = {
  SIGNIN: {
    SERVER: 'server error',
  },
  WORKSPACE: {
    LIST: 'get workspace list fail',
    INFO: 'get workspace info fail',
    MEMBERS: 'get workspace members fail',
    CHANNELS: 'get workspace channels fail',
    CREATE: 'create workspace fail',
  },
};

export const RESPONSE = {
  SIGNIN_SUCCESS: '11000',
  SIGNIN_FAIL: '11002',
};
