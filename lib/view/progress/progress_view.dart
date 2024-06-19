import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../common/color_extension.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../common_widget/round_button.dart';
import 'edit_progress_view.dart';

class ProgressView extends StatefulWidget {
  const ProgressView({super.key});

  @override
  State<ProgressView> createState() => _ProgressViewState();
}

class _ProgressViewState extends State<ProgressView> {
  FirebaseAuth auth = FirebaseAuth.instance;
  List<Map<String, dynamic>>? userProgress;

  double currentWeight = 0;
  double heaviestWeight = 0;
  double lightestWeight = 0;
  double currentHeight = 0;

  User? getCurrentUser() {
    User? user = auth.currentUser;
    return user;
  }

  Future<List<Map<String, dynamic>>?> getUserProgress() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
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

      List<dynamic>? weightProgress = userDoc.get('weightProgress');
      return weightProgress
          ?.map((item) => item as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print('Error fetching weight progress: $e');
      return null;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchUserData();
  }

  void fetchUserData() async {
    var progress = await getUserProgress();
    var height = await getUserHeight();
    if (mounted) {
      setState(() {
        userProgress = progress;
        currentHeight = height;
        currentWeight = getCurrentWeight();
        heaviestWeight = getHeaviestWeight(userProgress);
        lightestWeight = getLightestWeight(userProgress);
      });
    }
  }

  int chartWidthFactor() {
    if (userProgress != null) {
      return (((userProgress ?? []).length) / 6).ceil();
    }
    return 1;
  }

  double calculateMaxY() {
    if (userProgress == null || userProgress!.isEmpty) {
      return 10.01; // A default value or minimum threshold
    }
    double maxY = userProgress!.fold<double>(0.0, (previousValue, element) {
      double weight = element['weight'].toDouble();
      return weight > previousValue ? weight : previousValue;
    });
    return maxY + 4; // Adding a buffer of 1 for better visibility
  }

  double calculateMinY() {
    if (userProgress == null || userProgress!.isEmpty) {
      return -0.01; // A default value or minimum threshold
    }
    double minY =
        userProgress!.fold<double>(double.maxFinite, (previousValue, element) {
      double weight = element['weight'].toDouble();
      return weight < previousValue ? weight : previousValue;
    });
    return minY - 4; // Adding a buffer of 1 for better visibility
  }

  double calculateHorizontalInterval() {
    return ((calculateMaxY() - calculateMinY()) / 10).ceil() * 2;
  }

  double getCurrentWeight() {
    if ((userProgress ?? []).isEmpty) return 0.0;
    return (userProgress ?? []).last['weight'].toDouble();
  }

  double getHeaviestWeight(List<dynamic>? userProgress) {
    if (userProgress == null || userProgress.isEmpty) {
      return 0.0;
    }

    double maxWeight = userProgress[0]['weight'].toDouble();
    for (var entry in userProgress) {
      if (entry['weight'] > maxWeight) {
        maxWeight = entry['weight'].toDouble();
      }
    }
    return maxWeight.toDouble();
  }

  double getLightestWeight(List<dynamic>? userProgress) {
    if (userProgress == null || userProgress.isEmpty) {
      return 0.0;
    }

    double minWeight = userProgress[0]['weight'].toDouble();
    for (var entry in userProgress) {
      if (entry['weight'] < minWeight) {
        minWeight = entry['weight'].toDouble();
      }
    }
    return minWeight.toDouble();
  }

  Future<double> getUserHeight() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
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

      double height = userDoc.get('height');
      return height;
    } catch (e) {
      print('Error fetching weight progress: $e');
      return 0;
    }
  }

  double calculateBMI(double height, double weight) {
    double mHeight = height / 100;
    return weight / (mHeight * mHeight);
  }

  String getBmiResult(double bmi) {
    if (bmi > 0 && bmi < 18.5) {
      return "Underweight";
    } else if (bmi >= 18.5 && bmi < 25) {
      return "Normal Weight";
    } else if (bmi >= 25 && bmi < 30) {
      return "Overweight";
    } else if (bmi >= 30 && bmi < 35) {
      return "Obesity Class 1";
    } else if (bmi >= 35 && bmi < 40) {
      return "Obesity Class 2";
    } else if (bmi >= 40) {
      return "Obesity Class 3";
    }
    return "No Result";
  }

  @override
  Widget build(BuildContext context) {
    double bmi = calculateBMI(currentHeight, currentWeight);
    String resultBMI = getBmiResult(bmi);
    print(bmi);
    print(resultBMI);
    var media = MediaQuery.of(context).size;
    double chartWidth = media.width * chartWidthFactor();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColor.white,
        centerTitle: true,
        elevation: 0,
        leadingWidth: 0,
        title: Text(
          "Progress",
          style: TextStyle(
              color: TColor.gray, fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
      backgroundColor: TColor.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: media.width * 0.05,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Weight Progress",
                      style: TextStyle(
                          color: TColor.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w700),
                    ),
                    SizedBox(
                      width: 115,
                      height: 25,
                      child: RoundButton(
                        title: "Add Progress",
                        type: RoundButtonType.bgGradient,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UpdateProgressView(
                                  userProgress: userProgress),
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: media.width * 0.04,
                ),
                Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                  padding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                  decoration: BoxDecoration(
                      color: TColor.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(color: Colors.black12, blurRadius: 2)
                      ]),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
                        padding: const EdgeInsets.only(left: 0, right: 25),
                        width: chartWidth,
                        height: media.width * 0.5,
                        child: LineChart(
                          LineChartData(
                            lineBarsData: lineBarsData1,
                            minY: calculateMinY(),
                            maxY: calculateMaxY(),
                            titlesData: FlTitlesData(
                                show: true,
                                leftTitles: AxisTitles(sideTitles: leftTitles),
                                topTitles: AxisTitles(sideTitles: topTitles),
                                bottomTitles:
                                    AxisTitles(sideTitles: bottomTitles),
                                rightTitles: AxisTitles()),
                            gridData: FlGridData(
                              show: true,
                              drawHorizontalLine: true,
                              horizontalInterval: calculateHorizontalInterval(),
                              drawVerticalLine: false,
                              getDrawingHorizontalLine: (value) {
                                return FlLine(
                                  color: TColor.gray.withOpacity(0.05),
                                  strokeWidth: 2,
                                );
                              },
                            ),
                            borderData: FlBorderData(
                              show: true,
                              border: Border.all(
                                color: Colors.transparent,
                              ),
                            ),
                          ),
                        )),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8), // Adjust padding as needed
                  color: Colors.white, // Adjust the color as needed
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 16), // Spacing between title and items
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('Current',
                              style:
                                  TextStyle(fontSize: 14, color: TColor.gray)),
                          Text('${currentWeight} kg',
                              style:
                                  TextStyle(fontSize: 14, color: TColor.gray)),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('Heaviest',
                              style:
                                  TextStyle(fontSize: 14, color: TColor.gray)),
                          Text('${heaviestWeight} kg',
                              style:
                                  TextStyle(fontSize: 14, color: TColor.gray)),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('Lightest',
                              style:
                                  TextStyle(fontSize: 14, color: TColor.gray)),
                          Text('${lightestWeight} kg',
                              style:
                                  TextStyle(fontSize: 14, color: TColor.gray)),
                        ],
                      ),
                      SizedBox(height: 16), // Spacing between sections
                      Text('Height',
                          style: TextStyle(
                              fontSize: 16,
                              color: TColor.black,
                              fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('Current',
                              style:
                                  TextStyle(fontSize: 14, color: TColor.gray)),
                          Text('${currentHeight}',
                              style:
                                  TextStyle(fontSize: 14, color: TColor.gray)),
                        ],
                      ),
                      SizedBox(height: 16),
                      Text('BMI (kg/m²)',
                          style: TextStyle(
                              fontSize: 16,
                              color: TColor.black,
                              fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('${resultBMI}',
                              style:
                                  TextStyle(fontSize: 14, color: TColor.gray)),
                          Text('${bmi.toStringAsFixed(2)}',
                              style:
                                  TextStyle(fontSize: 14, color: TColor.gray)),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void sortUserProgress(List<Map<String, dynamic>>? userProgress) {
    (userProgress ?? []).sort((a, b) {
      Timestamp dateA = a['date'];
      Timestamp dateB = b['date'];
      return dateA.compareTo(dateB);
    });
  }

  List<LineChartBarData> get lineBarsData1 => [
        lineChartBarData1_1,
      ];

  LineChartBarData get lineChartBarData1_1 {
    sortUserProgress(userProgress);
    // Assuming userProgress is available and is a List<Map<String, dynamic>>
    List<FlSpot> spots = (userProgress ?? []).asMap().entries.map((entry) {
      int index = entry.key;
      double weight = entry.value['weight'].toDouble();
      return FlSpot(index.toDouble(), weight);
    }).toList();

    return LineChartBarData(
      isCurved: true,
      gradient: LinearGradient(colors: [
        TColor.primaryColor2,
        TColor.primaryColor1,
      ]),
      barWidth: 1,
      isStrokeCapRound: true,
      dotData: FlDotData(show: true),
      belowBarData: BarAreaData(
        show: true,
        gradient: LinearGradient(colors: [
          TColor.primaryColor2,
          TColor.white,
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
      ),
      spots: spots, // Use the dynamically generated spots
    );
  }

  SideTitles get bottomTitles => SideTitles(
        showTitles: true,
        reservedSize: 32,
        interval: 1,
        getTitlesWidget: bottomTitleWidgets,
      );

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    var style = TextStyle(
      color: TColor.gray,
      fontSize: 11,
    );
    // Check if the value is within the range of the list
    if (value < 0 || value >= (userProgress ?? []).length) {
      return SideTitleWidget(
        axisSide: meta.axisSide,
        space: 10,
        child: Text('', style: style),
      );
    }

    // Convert the Timestamp to DateTime
    Timestamp timestamp = userProgress?[value.toInt()]['date'];
    DateTime dateTime = timestamp.toDate();

    // Format the DateTime to a readable string
    String formattedDate =
        DateFormat('dd').format(dateTime); // Adjust the format as needed

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10,
      child: Text(formattedDate, style: style),
    );
  }

  SideTitles get topTitles => SideTitles(
        showTitles: true,
        reservedSize: 32,
        interval: 1,
        getTitlesWidget: topTitleWidgets,
      );

  Widget topTitleWidgets(double value, TitleMeta meta) {
    var style = TextStyle(
      color: TColor.gray,
      fontSize: 11,
    );
    // Check if the value is within the range of the list
    if (value < 0 || value >= (userProgress ?? []).length) {
      return SideTitleWidget(
        axisSide: meta.axisSide,
        space: 10,
        child: Text('', style: style),
      );
    }

    // Convert the Timestamp to DateTime
    Timestamp timestamp = userProgress?[value.toInt()]['date'];
    DateTime dateTime = timestamp.toDate();

    // Check if the next data point has a different year
    bool isYearChange = false;
    if (value.toInt() < userProgress!.length - 1) {
      Timestamp nextTimestamp = userProgress![value.toInt() + 1]['date'];
      DateTime nextDateTime = nextTimestamp.toDate();
      isYearChange = nextDateTime.year != dateTime.year;
    }

    // Format the DateTime to a readable string
    String formattedDate =
        DateFormat('MMM').format(dateTime); // Adjust the format as needed
    if (isYearChange) {
      formattedDate += ' ${dateTime.year}';
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10,
      child: Text(formattedDate, style: style),
    );
  }

  SideTitles get leftTitles => SideTitles(
        showTitles: true,
        reservedSize: 32,
        interval: 1,
        getTitlesWidget: leftTitleWidgets,
      );

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    var style = TextStyle(
      color: TColor.gray,
      fontSize: 11,
    );

    double maxY = calculateMaxY();
    double minY = calculateMinY();
    double range = maxY - minY;
    double interval = range / 3; // Dividing the range into three parts

    // Finding the intermediate values
    double midValue1 = minY + interval;
    double midValue2 = minY + 2 * interval;

    String labelText;
    if (value == minY) {
      labelText = '${minY.toInt()}'; // Min weight as integer
    } else if (value == maxY) {
      labelText = '${maxY.toInt()}'; // Max weight as integer
    } else if (value == midValue1) {
      labelText = '${midValue1.toInt()}'; // First intermediate value as integer
    } else if (value == midValue2) {
      labelText =
          '${midValue2.toInt()}'; // Second intermediate value as integer
    } else {
      labelText = ''; // Empty for other values
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10,
      child: Text(labelText, style: style),
    );
  }
}
