export const HOST = process.env.REACT_APP_BACKEND_HOST;

export const ERROR_MESSAGE = {
  SIGNIN: {
    WRONG: 'wrong email or password',
  },
  WORKSPACE: {
    LIST: 'get workspace list fail',
    INFO: 'get workspace info fail',
    MEMBERS: 'get workspace members fail',
    CHANNELS: 'get workspace channels fail',
    CREATE: 'create workspace fail',
  },
};
