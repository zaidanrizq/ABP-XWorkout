import 'package:xworkout/common_widget/round_button.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:xworkout/view/main_tab/main_tab_view.dart';

import '../../common/color_extension.dart';
import '../../common_widget/round_textfield.dart';

class UpdateProgressView extends StatefulWidget {
  final List<Map<String, dynamic>>? userProgress;

  const UpdateProgressView({Key? key, this.userProgress}) : super(key: key);

  @override
  State<UpdateProgressView> createState() => _UpdateProgressViewState();
}

class _UpdateProgressViewState extends State<UpdateProgressView> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  DateTime selectedDate = DateTime.now();
  String labelDate = "Select Date";
  late double weight;
  late double currentWeight;
  late Timestamp dateProgress;
  List<Map<String, dynamic>>? updatedProgress;

  User? getCurrentUser() {
    User? user = auth.currentUser;
    return user;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }

    setState(() {
      labelDate = (selectedDate.day).toString() +
          "-" +
          (selectedDate.month).toString() +
          "-" +
          (selectedDate.year).toString();
    });

    dateProgress = Timestamp.fromDate(selectedDate);
  }

  void sortUserProgress(List<Map<String, dynamic>>? userProgress) {
    (userProgress ?? []).sort((a, b) {
      Timestamp dateA = a['date'];
      Timestamp dateB = b['date'];
      return dateA.compareTo(dateB);
    });
  }

  double getCurrentWeight(List<Map<String, dynamic>>? userProgress) {
    if ((userProgress ?? []).isEmpty) return 0.0;
    return (userProgress ?? []).last['weight'].toDouble();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          "Update Progress",
          style: TextStyle(
              color: TColor.black, fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
      backgroundColor: TColor.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Column(
          children: [
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
                    hitText: "Your Weight",
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
            const Spacer(),
            RoundButton(
                title: "Update",
                onPressed: () {
                  try {
                    User? user = FirebaseAuth.instance.currentUser;
                    if (user == null) {
                      throw Exception('No user logged in');
                    }
                    Map<String, dynamic> progress;
                    if (widget.userProgress == null) {
                      updatedProgress = [];
                      progress = {'date': dateProgress, 'weight': weight};
                      updatedProgress?.add(progress);
                      firestore.collection('users').doc(user.uid).update({
                        'weight': currentWeight,
                        'weightProgress': updatedProgress
                      });
                    } else {
                      bool isProgressThere = false;
                      updatedProgress = widget.userProgress;
                      for (var entry in (updatedProgress ?? [])) {
                        if (entry['date'] == dateProgress) {
                          isProgressThere = true;
                          entry['weight'] = weight;
                        }
                      }
                      if (!isProgressThere) {
                        DateTime dateProgressDateTime, currentDate;
                        dateProgressDateTime = dateProgress.toDate();
                        currentDate = DateTime.now();

                        if (currentDate.year == dateProgressDateTime.year &&
                            currentDate.month == dateProgressDateTime.month &&
                            currentDate.day == dateProgressDateTime.day) {
                          progress = {'date': dateProgress, 'weight': weight};
                          updatedProgress?.add(progress);
                          sortUserProgress(updatedProgress);
                          currentWeight = getCurrentWeight(updatedProgress);
                          firestore
                              .collection('users')
                              .doc(user.uid)
                              .update({'weightProgress': updatedProgress});
                        } else {
                          progress = {'date': dateProgress, 'weight': weight};
                          updatedProgress?.add(progress);
                          sortUserProgress(updatedProgress);
                          currentWeight = getCurrentWeight(updatedProgress);
                          firestore.collection('users').doc(user.uid).update({
                            'weight': currentWeight,
                            'weightProgress': updatedProgress
                          });
                        }
                      }
                    }
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
