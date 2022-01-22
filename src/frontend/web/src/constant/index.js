export const URL = {
  HOST: process.env.REACT_APP_BACKEND_HOST,
  REDIRECT_HOME: 'http://localhost:3000',
};

export const ENDPOINT = {
  SIGNIN: '/auth/login',
};

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

export const TOKEN = {
  ACCESS: 'access_token',
  REFRESH: 'refresh_token',
};
