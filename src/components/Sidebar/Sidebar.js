import React from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { useFirebase } from '../Firebase/context'; // Adjusted import path
import './Sidebar.css'; // Import your custom CSS
import Title from './../Title/Title'; // Import the Title component

const Sidebar = () => {
  const firebase = useFirebase();
  const navigate = useNavigate();

  const handleSignOut = () => {
    firebase.doSignOut()
      .then(() => navigate('/sign-in'))
      .catch(error => console.error("Error signing out: ", error));
  };

  return (
    <div className="sidebar">
      <Title />
      <div className="sidebar-content">
        <ul className="sidebar-list">
          <li className="sidebar-item">
            <Link to="/workout" className="sidebar-link">Workout</Link>
          </li>
          <li className="sidebar-item">
            <Link to="/weight-tracker" className="sidebar-link">Weight Tracker</Link>
          </li>
          <li className="sidebar-item">
            <Link to="/profile" className="sidebar-link">Profile</Link>
          </li>
          <li className="sidebar-item">
            <button className="signout-button" onClick={handleSignOut}>Sign Out</button>
          </li>
        </ul>
      </div>
    </div>
  );
};

export default Sidebar;
