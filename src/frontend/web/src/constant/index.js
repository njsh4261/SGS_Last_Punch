export const URL = {
  HOST: process.env.REACT_APP_BACKEND_HOST,
  REDIRECT_HOME: 'http://localhost:3000',
};

export const HEADER = {
  X_AUTH_TOKEN: 'X-AUTH-TOKEN',
};

export const ENDPOINT = {
  SIGNIN: '/auth/login',
  SIGNUP: '/auth/signup',
  REISSUE: '/auth/reissue',
  DUPLICATE: '/auth/email-duplicate',
  SEND_EMAIL: '/auth/email',
  VERIFY: '/auth/email-verification',
};

export const ERROR_MESSAGE = {
  SERVER: 'server error',
  SIGNUP: {
    DUPLICATE: 'DUPLICATE_EMAIL',
    INVALID_VERIFY_CODE: 'INVALID_VERIFY_CODE',
  },
  WORKSPACE: {
    LIST: 'get workspace list fail',
    INFO: 'get workspace info fail',
    MEMBERS: 'get workspace members fail',
    CHANNELS: 'get workspace channels fail',
    CREATE: 'create workspace fail',
  },
  UNKNOWN: 'unknown error',
};

export const RESPONSE = {
  TOKEN: {
    SUCCESS: '10000',
    NO: '10001',
    EXPIRED: '10002',
    MALFORMED: '10003',
    DECODING: '10004',
    INTERNAL_SERVER_ERROR: '10999',
  },
  SIGNIN: {
    SUCCESS: '11000',
    FAIL: '11002',
  },
  WORKSPACE: {
    SUCCESS: '12000',
  },
};

export const TOKEN = {
  ACCESS: 'access_token',
  REFRESH: 'refresh_token',
};
