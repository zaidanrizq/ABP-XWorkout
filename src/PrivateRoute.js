// PrivateRoute.js
import React, { useContext } from 'react';
import { Navigate } from 'react-router-dom';
import FirebaseContext from './components/Firebase/context'; // Adjusted import path
import { useAuthState } from 'react-firebase-hooks/auth';

const PrivateRoute = ({ children }) => {
  const firebase = useContext(FirebaseContext);
  const [user, loading] = useAuthState(firebase.auth);

  if (loading) {
    return <div>Loading...</div>;
  }

  return user ? children : <Navigate to="/sign-in" />;
};

export default PrivateRoute;
