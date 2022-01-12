import 'styled-components';

declare module 'styled-components' {
  export interface DefaultTheme {
    color: {
      slack: string;
      lightSlack: string;
    };
  }
}
