import React, { useEffect, useState } from 'react';
import { useParams } from 'react-router-dom';
import { useFirebase } from '../components/Firebase/context';
import YouTube from 'react-youtube';
import Sidebar from '../components/Sidebar/Sidebar'; // Import the Sidebar component
import './MoveDetail.css';

const MoveDetail = () => {
  const { exerciseId, muscleId, moveId } = useParams();
  const firebase = useFirebase();
  const [move, setMove] = useState(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchMove = async () => {
      try {
        const moveDoc = await firebase.doGetMoveDetails(exerciseId, muscleId, moveId);
        setMove(moveDoc);
        setLoading(false);
      } catch (error) {
        alert(error);
        console.error("Error fetching move details: ", error);
        setLoading(false);
      }
    };

    fetchMove();
  }, [firebase, exerciseId, muscleId, moveId]);

  if (loading) {
    return (
      <div className="loading-container">
        <div className="loading-spinner"></div>
      </div>
    );
  }

  if (!move) {
    return <div className="error-container">Move not found.</div>;
  }

  const { description, name, steps, videoUrl } = move;

  // Function to extract the video ID from the URL
  const getVideoId = (url) => {
    const urlObj = new URL(url);
    if (urlObj.hostname === 'youtu.be') {
      return urlObj.pathname.slice(1);
    } else if (urlObj.hostname.includes('youtube.com')) {
      return urlObj.searchParams.get('v');
    }
    return null;
  };

  const videoId = getVideoId(videoUrl);

  return (
    <div className="move-detail-page">
      <Sidebar /> {/* Render the Sidebar */}
      <div className="move-detail-content">
        <div className="move-detail-root">
          <div className="move-header">
            <YouTube videoId={videoId} className="youtube-player" />
            <h1>{name}</h1>
            <p className="move-description">{description}</p>
          </div>
          <div className="move-steps">
            <h2>Steps</h2>
            <ol className="steps-list">
              {steps.map((step, index) => (
                <li key={index} className="step-item">
                  <strong>Step {step.no}:</strong> {step.detail}
                </li>
              ))}
            </ol>
          </div>
        </div>
      </div>
    </div>
  );
};

export default MoveDetail;