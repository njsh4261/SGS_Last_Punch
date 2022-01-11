import React from 'react';
import ReactDOM from 'react-dom';
import App from './App';
import GlobalStyle from './styles/GlobalStyle';
import { createStore, applyMiddleware } from 'redux';
import { Provider } from 'react-redux';
import createSagaMiddleware from 'redux-saga';
import { BrowserRouter } from 'react-router-dom';
import rootReducer, { rootSaga } from './modules';
import { ThemeProvider } from 'styled-components';
import { theme } from './styles/theme';

const sagaMiddleware = createSagaMiddleware();

const store = createStore(rootReducer, applyMiddleware(sagaMiddleware));

sagaMiddleware.run(rootSaga);

ReactDOM.render(
  <React.StrictMode>
    <ThemeProvider theme={theme}>
      <GlobalStyle />
      <Provider store={store}>
        <BrowserRouter>
          <App />
        </BrowserRouter>
      </Provider>
    </ThemeProvider>
  </React.StrictMode>,
  document.getElementById('root'),
);
