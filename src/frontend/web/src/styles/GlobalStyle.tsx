import { createGlobalStyle } from 'styled-components';

const GlobalStyle = createGlobalStyle`
  *, *::before, *::after {
    box-sizing: border-box;
  }

  html, body, body>div {
    font-family: "Helvetica", "Arial", sans-serif;
    overflow: hidden;
    height: 100%;
    margin: 0;
  }
`;

export default GlobalStyle;
