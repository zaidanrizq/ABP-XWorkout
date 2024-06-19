import * as React from 'react';
import Avatar from '@mui/material/Avatar';
import Button from '@mui/material/Button';
import CssBaseline from '@mui/material/CssBaseline';
import TextField from '@mui/material/TextField';
import FormControlLabel from '@mui/material/FormControlLabel';
import Checkbox from '@mui/material/Checkbox';
import Paper from '@mui/material/Paper';
import Box from '@mui/material/Box';
import Grid from '@mui/material/Grid';
import LockOutlinedIcon from '@mui/icons-material/LockOutlined';
import Typography from '@mui/material/Typography';
import Radio from '@mui/material/Radio';
import RadioGroup from '@mui/material/RadioGroup';
import FormControl from '@mui/material/FormControl';
import FormLabel from '@mui/material/FormLabel';
import { createTheme, ThemeProvider } from '@mui/material/styles';
import { Link, useNavigate } from 'react-router-dom';
import { withFirebase } from '../components/Firebase';

function Copyright(props) {
    return (
      <Typography variant="body2" color="text.secondary" align="center" {...props}>
        {'Copyright © '}
        <Link color="inherit" href="https://mui.com/">
          Your Website
        </Link>{' '}
        {new Date().getFullYear()}
        {'.'}
      </Typography>
    );
}

const defaultTheme = createTheme();

function SignUpSide({ firebase }) {
  const [user, setUser] = React.useState({
    firstName: '',
    lastName: '',
    birthDate: '',
    weight: '',
    height: '',
    gender: '',
    email: '',
    password: '',
    error: null,
  });

  const navigate = useNavigate();

  const handleChange = (event) => {
    const { name, value } = event.target;
    setUser({ ...user, [name]: value });
  };

  const handleSubmit = (event) => {
    event.preventDefault();
    firebase.doCreateUserWithEmailAndPassword(user.email, user.password)
      .then((authUser) => {
        const { uid } = authUser.user;
        const userData = {
            firstName: user.firstName,
            lastName: user.lastName,
            birthDate: firebase.doConvertToTimestamp(user.birthDate),
            weight: user.weight,
            height: user.height,
            gender: user.gender,
            email: user.email,
        };
        return firebase.doSetUserDocument(uid, userData);
      })
      .then(() => {
        setUser({
          firstName: '',
          lastName: '',
          birthDate: '',
          weight: '',
          height: '',
          gender: '',
          email: '',
          password: '',
          error: null,
        });
        navigate('/workout');
      })
      .catch((error) => {
        setUser({ ...user, error: error.message });
      });
  };

  const isValid = user.firstName === '' || user.lastName === '' || user.email === '' || user.password === '';

  return (
    <ThemeProvider theme={defaultTheme}>
      <Grid container component="main" sx={{ height: '100vh' }}>
        <CssBaseline />
        <Grid
          item
          xs={false}
          sm={4}
          md={7}
          sx={{
            backgroundImage: 'url(https://raw.githubusercontent.com/zaidanrizq/xworkout/2116e7a0d7db36cb8a8b38d2117c1fc41466a4ca/assets/img/bg/auth_wallpaper.jpg)',
            backgroundRepeat: 'no-repeat',
            backgroundAttachment: 'fixed',
            backgroundSize: 'cover',
            backgroundPosition: 'center',
          }}
        />
        <Grid item xs={12} sm={8} md={5} component={Paper} elevation={6} square>
          <Box
            sx={{
              my: 8,
              mx: 4,
              display: 'flex',
              flexDirection: 'column',
              alignItems: 'center',
            }}
          >
            <Avatar sx={{ m: 1, bgcolor: 'secondary.main' }}>
              <LockOutlinedIcon />
            </Avatar>
            <Typography component="h1" variant="h5">
              Sign Up
            </Typography>
            <Box component="form" noValidate onSubmit={handleSubmit} sx={{ mt: 1 }}>
              <TextField
                margin="normal"
                required
                fullWidth
                id="firstName"
                label="First Name"
                name="firstName"
                autoComplete="given-name"
                autoFocus
                value={user.firstName}
                onChange={handleChange}
              />
              <TextField
                margin="normal"
                required
                fullWidth
                id="lastName"
                label="Last Name"
                name="lastName"
                autoComplete="family-name"
                value={user.lastName}
                onChange={handleChange}
              />
              <TextField
                margin="normal"
                required
                fullWidth
                id="birthDate"
                label="Birthdate"
                name="birthDate"
                type="date"
                InputLabelProps={{
                  shrink: true,
                }}
                value={user.birthDate}
                onChange={handleChange}
              />
              <TextField
                margin="normal"
                required
                fullWidth
                id="weight"
                label="Weight (kg)"
                name="weight"
                type="number"
                value={user.weight}
                onChange={handleChange}
              />
              <TextField
                margin="normal"
                required
                fullWidth
                id="height"
                label="Height (cm)"
                name="height"
                type="number"
                value={user.height}
                onChange={handleChange}
              />
              <FormControl component="fieldset" sx={{ mt: 2, mb: 2, width: '100%' }}>
                <FormLabel component="legend">Gender</FormLabel>
                <RadioGroup row aria-label="gender" name="gender" value={user.gender} onChange={handleChange}>
                  <FormControlLabel value="female" control={<Radio />} label="Female" />
                  <FormControlLabel value="male" control={<Radio />} label="Male" />
                </RadioGroup>
              </FormControl>
              <TextField
                margin="normal"
                required
                fullWidth
                id="email"
                label="Email Address"
                name="email"
                autoComplete="email"
                value={user.email}
                onChange={handleChange}
              />
              <TextField
                margin="normal"
                required
                fullWidth
                name="password"
                label="Password"
                type="password"
                id="password"
                autoComplete="current-password"
                value={user.password}
                onChange={handleChange}
              />
              {user.error && (
                <Typography color="error" sx={{ mt: 2 }}>
                  {user.error}
                </Typography>
              )}
              <FormControlLabel
                control={<Checkbox value="remember" color="primary" />}
                label="Remember me"
              />
              <Button
                type="submit"
                fullWidth
                variant="contained"
                sx={{ mt: 3, mb: 2 }}
                disabled={isValid}
              >
                Sign Up
              </Button>
              <Grid container>
                <Grid item>
                  <Link to="/sign-in" variant="body2">
                    {"Already have an account? Sign In"}
                  </Link>
                </Grid>
              </Grid>
              <Copyright sx={{ mt: 5 }} />
            </Box>
          </Box>
        </Grid>
      </Grid>
    </ThemeProvider>
  );
}

export default withFirebase(SignUpSide);