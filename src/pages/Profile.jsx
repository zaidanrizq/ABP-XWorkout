// src/pages/Profile.jsx

import React, { useEffect, useState } from 'react';
import { useFirebase } from '../components/Firebase/context';
import './Profile.css'; // Import CSS file for styling


const Profile = () => {
  const firebase = useFirebase();
  const [profileData, setProfileData] = useState({
    birthDate: null,
    firstName: '',
    lastName: '',
    gender: '',
    height: '',
    weight: '',
  });
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    const fetchProfileData = async () => {
      try {
        // Get the current user from Firebase authentication
        const currentUser = firebase.auth.currentUser;
        if (currentUser) {
          const currentUserUid = currentUser.uid;

          // Fetch user profile data using Firebase service method
          const data = await firebase.doGetUserProfile(currentUserUid);
          setProfileData({
            birthDate: data.birthDate.toDate(),
            firstName: data.firstName,
            lastName: data.lastName,
            gender: data.gender,
            height: data.height,
            weight: data.weight,
          });
        } else {
          throw new Error('No user logged in');
        }
      } catch (err) {
        setError(err.message);
      } finally {
        setLoading(false);
      }
    };

    fetchProfileData();
  }, [firebase]);

  if (loading) {
    return <p className="profile-loading">Loading...</p>;
  }

  if (error) {
    return <p className="profile-error">Error: {error}</p>;
  }

  return (
    <div className="profile-container">
      <h1 className="profile-heading">Profile</h1>
      <div className="profile-info">
        <p><strong>First Name:</strong> {profileData.firstName}</p>
        <p><strong>Last Name:</strong> {profileData.lastName}</p>
        <p><strong>Gender:</strong> {profileData.gender}</p>
        <p><strong>Height:</strong> {profileData.height} cm</p>
        <p><strong>Weight:</strong> {profileData.weight} kg</p>
        <p><strong>Birth Date:</strong> {profileData.birthDate.toDateString()}</p>
      </div>
    </div>
  );
};

export default Profile;
