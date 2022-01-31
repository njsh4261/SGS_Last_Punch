import React from 'react';
import { Routes, Route, Navigate, Outlet } from 'react-router-dom';
import Note from '../pages/Note';

export default function TestRoute() {
  return (
    <Routes>
      <Route path="/" element={<Note></Note>}>
        <Route path=":noteId" element={<Note></Note>}></Route>
      </Route>
    </Routes>
  );
}
