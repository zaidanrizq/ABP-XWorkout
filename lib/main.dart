import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:xworkout/view/home/home_view.dart';
import 'package:xworkout/view/login/complete_profile_view.dart';
import 'package:xworkout/view/login/login_view.dart';
import 'package:xworkout/view/login/signup_view.dart';
import 'package:xworkout/view/login/welcome_view.dart';
import 'package:xworkout/view/main_tab/main_tab_view.dart';
import 'package:xworkout/view/progress/progress_view.dart';
import 'common/color_extension.dart';
import 'package:xworkout/view/on_boarding/started_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: 'AIzaSyDMCM5v6i5O6CmQAM9M1ZwiJvFWdeSHShY',
        appId: '1:1063434588297:android:799f4754e7e30daf767658',
        messagingSenderId: '1063434588297',
        projectId: 'xworkout-ecfe4',
        storageBucket: 'xworkout-ecfe4.appspot.com',
      )
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'XWorkout',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
          primaryColor: TColor.primaryColor1,
          fontFamily: "Poppins"),
      home: const StartedView(),
    );
  }
}
