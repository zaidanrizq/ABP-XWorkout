import 'package:flutter/material.dart';
import 'package:xworkout/view/main_tab/main_tab_view.dart';
import '../../common/color_extension.dart';
import '../../common_widget/round_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WelcomeView extends StatefulWidget {
  const WelcomeView({super.key});

  @override
  State<WelcomeView> createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  late User loggedInUser;

  Future<void> getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  Future<String> getUserFirstName() async {
    final userField =
    await _firestore.collection('users').doc(loggedInUser.uid).get();
    return userField.data()?['firstName'] ?? 'User';
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: TColor.white,
      body: FutureBuilder<void>(
        future: getCurrentUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return FutureBuilder<String>(
              future: getUserFirstName(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  String userFirstName = snapshot.data ?? 'User';
                  return SafeArea(
                    child: Container(
                      width: media.width,
                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SizedBox(
                            height: media.width * 0.1,
                          ),
                          Image.asset(
                            "assets/img/welcome.png",
                            width: media.width * 0.75,
                            fit: BoxFit.fitWidth,
                          ),
                          SizedBox(
                            height: media.width * 0.1,
                          ),
                          Text(
                            "Welcome, $userFirstName",
                            style: TextStyle(
                                color: TColor.black,
                                fontSize: 20,
                                fontWeight: FontWeight.w700),
                          ),
                          Text(
                            "You are all set now, let’s reach your\ngoals together with us",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: TColor.gray, fontSize: 12),
                          ),
                          const Spacer(),
                          RoundButton(
                            title: "Go To Home",
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const MainTabView()));
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                }
              },
            );
          }
        },
      ),
    );
  }
}
