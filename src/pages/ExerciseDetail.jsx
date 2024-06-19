import React, { useEffect, useState } from 'react';
import { useParams, Link } from 'react-router-dom';
import { useFirebase } from '../components/Firebase/context';
import Sidebar from '../components/Sidebar/Sidebar';
import './ExerciseDetail.css';

const ExerciseDetail = () => {
  const { id: exerciseId } = useParams();
  const firebase = useFirebase();
  const [moves, setMoves] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchMoves = async () => {
      try {
        const movesList = await firebase.doGetExerciseMoves(exerciseId);
        setMoves(movesList);
        setLoading(false);
      } catch (error) {
        alert(error);
        console.error("Error fetching moves: ", error);
        setLoading(false);
      }
    };

    fetchMoves();
  }, [firebase, exerciseId]);

  if (loading) {
    return (
      <div className="loading-container">
        <div className="loading-spinner"></div>
      </div>
    );
  }

  return (
    <div className="exercise-detail-page">
      <Sidebar />
      <main className="exercise-detail-content">
        <div className="exercise-detail-root">
          <h1>{exerciseId} Moves</h1>
          <div className="grid-container">
            {moves.map((move) => (
              <Link 
                to={`/move/${exerciseId}/${move.muscleId}/${move.id}`} 
                key={move.id} 
                className="grid-item"
              >
                <div className="card">
                  <img src={move.imageUrl} alt={move.name} className="media" />
                  <div className="card-content">
                    <h2>{move.name}</h2>
                  </div>
                </div>
              </Link>
            ))}
          </div>
        /</div>
      </main>
    </div>
  );
};

export default ExerciseDetail;