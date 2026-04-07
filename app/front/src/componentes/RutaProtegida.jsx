import React, { useContext } from 'react';
import { Navigate } from 'react-router-dom';
import { AuthContext } from "../context/AuthContext";

const RutaProtegida = ({ children }) => {
  const { idUser } = useContext(AuthContext);
  const isAuthenticated = localStorage.getItem('isAuthenticated');
  // LOG PARA DEPURAR: Veremos qué ve la ruta antes de echarte

  // Si el contexto dice que no está autenticado, fuera.
  if (!isAuthenticated) {
    return <Navigate to="/account" replace />;
  }

  // Si está autenticado, le dejamos pasar al Admin
  return children;
};

export default RutaProtegida;