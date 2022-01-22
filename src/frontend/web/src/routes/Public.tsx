import React from 'react';
import { Routes, Route, Navigate } from 'react-router-dom';
import SigninPage from '../pages/Signin';
import Signup from '../pages/Signup';

export default function PublicRoute() {
  return (
    <Routes>
      <Route path="/signin" element={<SigninPage />}></Route>
      <Route path="/signup" element={<Signup />}></Route>
      <Route path="/*" element={<Navigate to={'/signin'}></Navigate>}></Route>
    </Routes>
  );
}
