import React from 'react';
import { useNavigate } from 'react-router-dom';

export default function Welcome() {
  const navigate = useNavigate();
  const logoutHandler = () => {
    sessionStorage.clear();
    navigate('/login');
  };
  return (
    <div>
      <span>login success</span>
      <button onClick={logoutHandler}>logout</button>
    </div>
  );
}
