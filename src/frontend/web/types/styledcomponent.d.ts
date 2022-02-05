import 'styled-components';

declare module 'styled-components' {
  export interface DefaultTheme {
    color: {
      slack: string;
      lightSlack: string;
      lightGrey: string;
      heavySlack: string;
      snackBorder: string;
      snackHeader: string;
      snackSide: string;
      snackSideFont: string;
      snackSideHover: string;
    };
  }
}
