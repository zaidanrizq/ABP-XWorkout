import 'package:flutter/material.dart';
import 'package:xworkout/common_widget/exercise_row.dart';
import 'package:xworkout/view/exercise/chest_exercise_view.dart';
import 'package:xworkout/view/exercise/back_exercise_view.dart';
import 'package:xworkout/view/exercise/shoulder_exercise_view.dart';
import 'package:xworkout/view/exercise/tricep_exercise_view.dart';
import 'package:xworkout/view/exercise/ab_exercise_view.dart';
import 'package:xworkout/view/exercise/bicep_exercise_view.dart';
import 'package:xworkout/view/exercise/leg_exercise_view.dart';
import '../../common/color_extension.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  late User loggedInUser;
  String userFirstName = "";
  List<Map<String, dynamic>> exercisesList = [];

  Future<void> _loadData() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;

        final userField =
        await _firestore.collection('users').doc(loggedInUser.uid).get();
        userFirstName = userField.data()?['firstName'] ?? "";

        final exercises = await _firestore.collection('exercises').get();
        exercisesList = exercises.docs.map((exercise) {
          return {
            'exerciseId': exercise.id,
            'name': exercise.data()['name'],
            'image': exercise.data()['imgUrl'],
            'moves': exercise.data()['manyMoves']
          };
        }).toList();
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return FutureBuilder<void>(
      future: _loadData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: TColor.white,
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            backgroundColor: TColor.white,
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        } else {
          return Scaffold(
            backgroundColor: TColor.white,
            body: SingleChildScrollView(
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Welcome Back,",
                                style: TextStyle(color: TColor.gray, fontSize: 12),
                              ),
                              Text(
                                userFirstName,
                                style: TextStyle(
                                    color: TColor.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: media.width * 0.05,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Choose Your Exercise",
                            style: TextStyle(
                                color: TColor.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                      ListView.builder(
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: exercisesList.length,
                        itemBuilder: (context, index) {
                          var wObj = exercisesList[index];
                          return InkWell(
                            onTap: () {
                              if (wObj['name'] == "Chest") {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ChestExerciseView(eObj: wObj)));
                              } else if (wObj['name'] == "Back") {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            BackExerciseView(eObj: wObj)));
                              } else if (wObj['name'] == "Shoulder") {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ShoulderExerciseView(eObj: wObj)));
                              } else if (wObj['name'] == "Tricep") {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            TricepExerciseView(eObj: wObj)));
                              } else if (wObj['name'] == "Leg") {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            LegExerciseView(eObj: wObj)));
                              } else if (wObj['name'] == "Ab") {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            AbExerciseView(eObj: wObj)));
                              } else if (wObj['name'] == "Bicep") {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            BicepExerciseView(eObj: wObj)));
                              }
                            },
                            child: ExerciseRow(wObj: wObj),
                          );
                        },
                      ),
                      SizedBox(
                        height: media.width * 0.1,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
