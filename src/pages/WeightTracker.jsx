import React, { useEffect, useState, useContext } from 'react';
import { LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip, Legend, ResponsiveContainer } from 'recharts';
import FirebaseContext from '../components/Firebase/context'; // Adjusted import path
import Sidebar from '../components/Sidebar/Sidebar'; // Adjusted import path
import './WeightTracker.css'; // Import custom CSS

const WeightTracker = () => {
  const [weightProgress, setWeightProgress] = useState([]);
  const [weight, setWeight] = useState('');
  const [date, setDate] = useState('');
  const firebase = useContext(FirebaseContext);

  useEffect(() => {
    const fetchWeightProgress = async () => {
      const user = firebase.auth.currentUser;
      if (user) {
        try {
          const data = await firebase.doGetWeightProgress(user.uid);
          const formattedData = data.map(entry => ({
            date: entry.date.toDate().toLocaleDateString(),
            weight: entry.weight
          }));
          setWeightProgress(formattedData);
        } catch (error) {
          console.error("Error fetching weight progress:", error);
        }
      }
    };

    fetchWeightProgress();
  }, [firebase]);

  const handleSubmit = async (e) => {
    e.preventDefault();
    const user = firebase.auth.currentUser;
    if (user && weight && date) {
      try {
        await firebase.doAddWeightProgress(user.uid, parseFloat(weight), date);
        const updatedData = await firebase.doGetWeightProgress(user.uid);
        const formattedData = updatedData.map(entry => ({
          date: entry.date.toDate().toLocaleDateString(),
          weight: entry.weight
        }));
        setWeightProgress(formattedData);
        setWeight('');
        setDate('');
      } catch (error) {
        console.error("Error adding weight progress:", error);
      }
    }
  };

  return (
    <div className="weight-tracker-container">
      <Sidebar />
      <div className="weight-tracker-content">
        <div className="weight-tracker-root">
            <h1>Weight Tracker</h1>
            <form className="weight-form" onSubmit={handleSubmit}>
            <input 
                type="number" 
                value={weight} 
                onChange={(e) => setWeight(e.target.value)} 
                placeholder="Weight" 
                required 
            />
            <input 
                type="date" 
                value={date} 
                onChange={(e) => setDate(e.target.value)} 
                required 
            />
            <button type="submit">Add Progress</button>
            </form>

            <ResponsiveContainer width="100%" height={400}>
            <LineChart data={weightProgress}>
                <CartesianGrid strokeDasharray="3 3" />
                <XAxis dataKey="date" />
                <YAxis />
                <Tooltip />
                <Legend />
                <Line type="monotone" dataKey="weight" stroke="#8884d8" />
            </LineChart>
            </ResponsiveContainer>
        </div>
      </div>
    </div>
  );
};

export default WeightTracker;
