import 'package:xworkout/common_widget/round_button.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:xworkout/view/main_tab/main_tab_view.dart';

import '../../common/color_extension.dart';
import '../../common_widget/round_textfield.dart';

class EditProfileView extends StatefulWidget {
  final String? userFirstName;
  final String? userLastName;
  final double? userHeight;
  final double? userWeight;
  final DateTime? userBirthDate;

  const EditProfileView(
      {Key? key,
      this.userFirstName,
      this.userLastName,
      this.userHeight,
      this.userWeight,
      this.userBirthDate})
      : super(key: key);

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  DateTime selectedDate = DateTime.now();
  String labelDate = "Select Date";
  late double? weight;
  late double? height;
  late String? firstName;
  late String? lastName;
  late Timestamp birthDate;
  List<Map<String, dynamic>>? updatedProgress;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1960),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    } else {
      setState(() {
        selectedDate = (widget.userBirthDate ?? DateTime.now());
      });
    }

    setState(() {
      labelDate = (selectedDate.day).toString() +
          "-" +
          (selectedDate.month).toString() +
          "-" +
          (selectedDate.year).toString();
    });

    birthDate = Timestamp.fromDate(selectedDate);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    firstName = widget.userFirstName;
    lastName = widget.userLastName;
    weight = widget.userWeight;
    height = widget.userHeight;
    birthDate = Timestamp.fromDate((widget.userBirthDate ?? DateTime.now()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: TColor.white,
        centerTitle: true,
        elevation: 0,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            margin: const EdgeInsets.all(8),
            height: 40,
            width: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: TColor.lightGray,
                borderRadius: BorderRadius.circular(10)),
            child: Image.asset(
              "assets/img/black_btn.png",
              width: 15,
              height: 15,
              fit: BoxFit.contain,
            ),
          ),
        ),
        title: Text(
          "Edit Profile",
          style: TextStyle(
              color: TColor.black, fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
      backgroundColor: TColor.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Column(
          children: [
            RoundTextField(
              hitText: "${widget.userFirstName}",
              icon: "assets/img/user_text.png",
              onChanged: (value) {
                setState(() {
                  firstName = value;
                });
              },
            ),
            const SizedBox(
              height: 15,
            ),
            RoundTextField(
              hitText: "${widget.userLastName}",
              icon: "assets/img/user_text.png",
              onChanged: (value) {
                setState(() {
                  lastName = value;
                });
              },
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              decoration: BoxDecoration(
                  color: TColor.lightGray,
                  borderRadius: BorderRadius.circular(15)),
              child: Row(
                children: [
                  Container(
                      alignment: Alignment.center,
                      width: 50,
                      height: 50,
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Image.asset(
                        "assets/img/date.png",
                        width: 20,
                        height: 20,
                        fit: BoxFit.contain,
                        color: TColor.gray,
                      )),
                  Expanded(
                    child: MaterialButton(
                      padding: EdgeInsets.zero,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          labelDate,
                          style: TextStyle(color: TColor.gray, fontSize: 12),
                        ),
                      ),
                      onPressed: () {
                        _selectDate(context);
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              children: [
                Expanded(
                  child: RoundTextField(
                    hitText: "${widget.userWeight}",
                    keyboardType: TextInputType.number,
                    icon: "assets/img/weight.png",
                    onChanged: (value) {
                      weight = double.parse(value);
                    },
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Container(
                  width: 50,
                  height: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: TColor.secondaryG,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    "KG",
                    style: TextStyle(color: TColor.white, fontSize: 12),
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
                  child: RoundTextField(
                    keyboardType: TextInputType.number,
                    hitText: "${widget.userHeight}",
                    icon: "assets/img/hight.png",
                    onChanged: (value) {
                      height = double.parse(value);
                    },
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Container(
                  width: 50,
                  height: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: TColor.secondaryG,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    "CM",
                    style: TextStyle(color: TColor.white, fontSize: 12),
                  ),
                )
              ],
            ),
            const Spacer(),
            RoundButton(
                title: "Update",
                onPressed: () {
                  print(firstName);
                  print(lastName);
                  print(birthDate);
                  print(weight);
                  print(height);
                  try {
                    User? user = FirebaseAuth.instance.currentUser;
                    if (user == null) {
                      throw Exception('No user logged in');
                    }
                    firestore.collection('users').doc(user.uid).update({
                      'firstName': firstName,
                      'lastName': lastName,
                      'birthDate': birthDate,
                      'weight': weight,
                      'height': height
                    });
                  } catch (e) {
                    print('Error fetching weight progress: $e');
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MainTabView(),
                    ),
                  );
                }),
            const SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }
}
