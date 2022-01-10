import React from 'react';
import { useLocation } from 'react-router-dom';

export default function Welcome() {
  const { state } = useLocation();
  return <div>hello {JSON.stringify(state)}</div>;
}
