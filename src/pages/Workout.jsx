import React, { useEffect, useState } from 'react';
import { Link } from 'react-router-dom';
import { useFirebase } from '../components/Firebase/context';
import Sidebar from '../components/Sidebar/Sidebar';
import './Workout.css'; // Import your custom CSS

const Workout = () => {
  const firebase = useFirebase();
  const [exercises, setExercises] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchExercises = async () => {
      try {
        const exercisesList = await firebase.doGetExercises();
        setExercises(exercisesList);
        setLoading(false);
      } catch (error) {
        alert(error);
        console.error("Error fetching exercises: ", error);
        setLoading(false); // Stop loading even if there is an error
      }
    };

    fetchExercises();
  }, [firebase]);

  if (loading) {
    return (
      <div className="loading-container">
        <div className="loading-spinner"></div>
      </div>
    );
  }

  return (
    <div className="workout-page">
      <Sidebar className="sidebar" />
      <main className="workout-content">
        <div className="workout-root">
          <div className="grid-container">
            {exercises.map((exercise) => (
              <Link to={`/exercise/${exercise.id}`} key={exercise.id} className="grid-item">
                <div className="card">
                  <img src={exercise.imgUrl} alt={exercise.name} className="media" />
                  <div className="card-content">
                    <h2>{exercise.name}</h2>
                  </div>
                </div>
              </Link>
            ))}
          </div>
        </div>
      </main>
    </div>
  );
};

export default Workout;
