// App.js

import React from 'react';
import './App.css';
import { BrowserRouter as Router, Routes, Route, useLocation } from 'react-router-dom';
import Firebase from './components/Firebase/firebase';
import { FirebaseContext } from './components/Firebase'; // Adjusted import path
import SignIn from './pages/SignIn';
import SignUp from './pages/SignUp';
import Workout from './pages/Workout';
import ExerciseDetail from './pages/ExerciseDetail';
import MoveDetail from './pages/MoveDetail';
import WeightTracker from './pages/WeightTracker'; // Adjusted import path
import Profile from './pages/Profile';
import PrivateRoute from './PrivateRoute';
import Sidebar from './components/Sidebar/Sidebar'; // Import Sidebar component

const firebase = new Firebase();

const AppContent = () => {
  const location = useLocation();
  const showSidebar = !['/sign-in', '/sign-up'].includes(location.pathname);

  return (
    <div className="app-container">
      {showSidebar && <Sidebar />} {/* Conditionally render Sidebar */}
      <div className="content">
        <Routes>
          <Route exact path="/sign-in" element={<SignIn />} />
          <Route path="/sign-up" element={<SignUp />} />
          <Route 
            path="/workout" 
            element={
              <PrivateRoute>
                <Workout />
              </PrivateRoute>
            } 
          />
          <Route 
            path="/exercise/:id" 
            element={
              <PrivateRoute>
                <ExerciseDetail />
              </PrivateRoute>
            } 
          />
          <Route 
            path="/move/:exerciseId/:muscleId/:moveId" 
            element={
              <PrivateRoute>
                <MoveDetail />
              </PrivateRoute>
            } 
          />
          <Route 
            path="/weight-tracker" 
            element={
              <PrivateRoute>
                <WeightTracker />
              </PrivateRoute>
            }
          />
          <Route 
            path="/profile" 
            element={
              <PrivateRoute>
                <Profile />
              </PrivateRoute>
            }
          />
        </Routes>
      </div>
    </div>
  );
};

function App() {
  return (
    <FirebaseContext.Provider value={firebase}>
      <Router>
        <AppContent />
      </Router>
    </FirebaseContext.Provider>
  );
}

export default App;
