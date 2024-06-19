// Import the functions you need from the SDKs you need
import { initializeApp } from "firebase/app";
import { getAuth, createUserWithEmailAndPassword, signInWithEmailAndPassword, signOut, sendPasswordResetEmail } from "firebase/auth";
import { getFirestore, setDoc, getDoc, getDocs, doc, collection, Timestamp, updateDoc, arrayUnion  } from "firebase/firestore";
// import { getAnalytics } from "firebase/analytics"; // Uncomment if you need analytics


// Your web app's Firebase configuration
const firebaseConfig = {
  apiKey: "AIzaSyC4TQYmHEk5osHvW8T4PFhcEynwFCPaYoM",
  authDomain: "xworkout-ecfe4.firebaseapp.com",
  projectId: "xworkout-ecfe4",
  storageBucket: "xworkout-ecfe4.appspot.com",
  messagingSenderId: "1063434588297",
  appId: "1:1063434588297:web:a2090a73746dc8e0767658",
  measurementId: "G-N7D4CR3KHG"
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
// const analytics = getAnalytics(app); // Uncomment if you need analytics

class Firebase {
  constructor() {
    this.auth = getAuth(app);
    this.db = getFirestore(app);
  }

  /*** Authentication  ***/
  doCreateUserWithEmailAndPassword = (email, password) =>
    createUserWithEmailAndPassword(this.auth, email, password);

  doSignInWithEmailAndPassword = (email, password) =>
    signInWithEmailAndPassword(this.auth, email, password);

  doSignOut = () =>
    signOut(this.auth);

  doPasswordReset = (email) =>
    sendPasswordResetEmail(this.auth, email);

  /*** Firestore ***/
  doSetUserDocument = (uid, userData) =>
    setDoc(doc(this.db, 'users', uid), userData);

  doConvertToTimestamp = (dateString) => {
    alert(dateString);
    const date = new Date(dateString);
    alert(date);
    if (isNaN(date.getTime())) {
      throw new Error("Invalid date format");
    }
    return Timestamp.fromDate(date);
  }

  /*** Fetch Exercises ***/
  doGetExercises = async () => {
    const exercisesSnapshot = await getDocs(collection(this.db, 'exercises'));
    return exercisesSnapshot.docs.map(doc => ({
      id: doc.id,
      ...doc.data(),
    }));
  }

  doGetExerciseMoves = async (exerciseId) => {
    const targetMusclesSnapshot = await getDocs(collection(this.db, 'exercises', exerciseId, 'targetMuscles'));
    const movesPromises = targetMusclesSnapshot.docs.map(async (muscleDoc) => {
      const movesCollectionRef = collection(this.db, 'exercises', exerciseId, 'targetMuscles', muscleDoc.id, 'moves');
      const movesSnapshot = await getDocs(movesCollectionRef);
      return movesSnapshot.docs.map(moveDoc => ({
        id: moveDoc.id,
        muscleId: muscleDoc.id, // Include muscleId here
        ...moveDoc.data()
      }));
    });
    return (await Promise.all(movesPromises)).flat();
  }

  doGetMoveDetails = async (exerciseId, muscleId, moveId) => {
    const moveDocRef = doc(this.db, 'exercises', exerciseId, 'targetMuscles', muscleId, 'moves', moveId);
    const moveDocSnapshot = await getDoc(moveDocRef);
    if (!moveDocSnapshot.exists()) {
      throw new Error('Move not found');
    }
    return moveDocSnapshot.data();
  }

  /*** Fetch User Profile ***/
  doGetUserProfile = async (uid) => {
    const userDocRef = doc(this.db, 'users', uid);
    const userDocSnapshot = await getDoc(userDocRef);

    if (!userDocSnapshot.exists()) {
      throw new Error('User not found');
    }

    return userDocSnapshot.data();
  }

  /*** Fetch Weight Progress ***/
doGetWeightProgress = async (uid) => {
  const userDocRef = doc(this.db, 'users', uid);
  const userDocSnapshot = await getDoc(userDocRef);
  
  if (!userDocSnapshot.exists()) {
    throw new Error('User not found');
  }
  
  const userData = userDocSnapshot.data();
  return userData.weightProgress || [];
}

doAddWeightProgress = async (uid, weight, date) => {
  const userDocRef = doc(this.db, 'users', uid);
  const newEntry = {
    weight,
    date: this.doConvertToTimestamp(date)
  };
  await updateDoc(userDocRef, {
    weightProgress: arrayUnion(newEntry)
  });
}

}

export default Firebase;