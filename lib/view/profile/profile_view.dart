import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:xworkout/view/on_boarding/started_view.dart';
import 'package:xworkout/view/profile/edit_profile_view.dart';

import '../../common/color_extension.dart';
import '../../common_widget/round_button.dart';
import '../../common_widget/setting_row.dart';
import '../../common_widget/title_subtitle_cell.dart';
import '../main_tab/main_tab_view.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  FirebaseAuth auth = FirebaseAuth.instance;
  String userFirstName = "";
  String userLastName = "";
  double userHeight = 0.0;
  double userWeight = 0.0;
  DateTime birthDate = DateTime.now();
  int userAge = 0;
  bool positive = false;

  User? getCurrentUser() {
    User? user = auth.currentUser;
    return user;
  }

  void fetchUserData() async {
    try {
      User? user = auth.currentUser;
      if (user == null) {
        throw Exception('No user logged in');
      }

      DocumentSnapshot<Map<String, dynamic>> userDoc = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (!userDoc.exists) {
        throw Exception('User document does not exist');
      }

      Timestamp birthDateTimeStamp;
      DateTime currentDate;
      int age;
      birthDateTimeStamp = userDoc.get('birthDate');
      birthDate = birthDateTimeStamp.toDate();
      currentDate = DateTime.now();
      age = currentDate.year - birthDate.year;
      if (currentDate.month < birthDate.month ||
          (currentDate.month == birthDate.month &&
              currentDate.day < birthDate.day)) {
        age--;
      }

      setState(() {
        userFirstName = userDoc.get("firstName");
        userLastName = userDoc.get("lastName");
        userHeight = userDoc.get("height");
        userWeight = userDoc.get("weight");
        birthDate = birthDateTimeStamp.toDate();
        userAge = age;
      });
    } catch (e) {
      print('Error fetching weight progress: $e');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchUserData();
  }

  List accountArr = [
    {"image": "assets/img/p_personal.png", "name": "Personal Data", "tag": "1"},
    {
      "image": "assets/img/p_workout.png",
      "name": "Workout Progress",
      "tag": "4"
    }
  ];

  @override
  Widget build(BuildContext context) {
    print(userFirstName);
    print(userLastName);
    print(userWeight);
    print(userHeight);
    print(birthDate);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColor.white,
        centerTitle: true,
        elevation: 0,
        leadingWidth: 0,
        title: Text(
          "Profile",
          style: TextStyle(
              color: TColor.gray, fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
      backgroundColor: TColor.white,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Image.asset(
                      "assets/img/u2.png",
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${userFirstName} ${userLastName}",
                          style: TextStyle(
                            color: TColor.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 70,
                    height: 25,
                    child: RoundButton(
                      title: "Edit",
                      type: RoundButtonType.bgGradient,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditProfileView(
                                userFirstName: userFirstName,
                                userLastName: userLastName,
                                userHeight: userHeight,
                                userWeight: userWeight,
                                userBirthDate: birthDate),
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Expanded(
                    child: TitleSubtitleCell(
                      title: "${userHeight} cm",
                      subtitle: "Height",
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: TitleSubtitleCell(
                      title: "${userWeight} kg",
                      subtitle: "Weight",
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: TitleSubtitleCell(
                      title: "${userAge} yo",
                      subtitle: "Age",
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 25,
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                decoration: BoxDecoration(
                    color: TColor.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: 2)
                    ]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Account",
                      style: TextStyle(
                        color: TColor.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: accountArr.length,
                      itemBuilder: (context, index) {
                        var iObj = accountArr[index] as Map? ?? {};
                        return SettingRow(
                          icon: iObj["image"].toString(),
                          title: iObj["name"].toString(),
                          onPressed: () {},
                        );
                      },
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              RoundButton(
                  title: "Log Out",
                  onPressed: () async {
                    try {
                      await FirebaseAuth.instance.signOut();
                      // Optionally navigate the user to a different screen after logging out
                      // For example, to the login screen:
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const StartedView()));
                    } catch (e) {
                      // Handle any errors here
                      print('Error logging out: $e');
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }
}
