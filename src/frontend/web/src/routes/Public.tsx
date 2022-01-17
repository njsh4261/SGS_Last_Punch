import React from 'react';
import { Routes, Route, Navigate } from 'react-router-dom';
import LoginPage from '../pages/Login';
import Signup from '../pages/Signup';

export default function PublicRoute() {
  return (
    <Routes>
      <Route path="/login" element={<LoginPage />}></Route>
      <Route path="/signup" element={<Signup />}></Route>
      <Route path="/*" element={<Navigate to={'/login'}></Navigate>}></Route>
    </Routes>
  );
}
