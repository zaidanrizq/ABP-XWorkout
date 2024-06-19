import React, { useContext } from 'react';

const FirebaseContext = React.createContext(null);

export const useFirebase = () => {
  return useContext(FirebaseContext);
};

export const withFirebase = Component => props => (
  <FirebaseContext.Consumer>
    {firebase => <Component {...props} firebase={firebase} />}
  </FirebaseContext.Consumer>
);

export default FirebaseContext;
