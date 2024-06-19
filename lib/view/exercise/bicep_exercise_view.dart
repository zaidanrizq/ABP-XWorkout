import 'package:flutter/material.dart';
import '../../common/color_extension.dart';
import '../../common_widget/move_row.dart';
import 'package:xworkout/view/exercise/move_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BicepExerciseView extends StatefulWidget {
  final Map eObj;
  const BicepExerciseView({super.key, required this.eObj});

  @override
  State<BicepExerciseView> createState() => _BicepExerciseViewState();
}

class _BicepExerciseViewState extends State<BicepExerciseView> {
  final _firestore = FirebaseFirestore.instance;

  TextEditingController txtSearch = TextEditingController();

  List<Map<String, dynamic>> bicepMovesList = [];

  void getBicepMoves() async {
    final moves = await _firestore
        .collection('exercises')
        .doc('bicepExercise')
        .collection('targetMuscles')
        .doc('biceps')
        .collection('moves')
        .get();

    bicepMovesList = moves.docs.map((move) {
      return {
        'targetMuscleId': 'biceps',
        'moveId': move.id,
        'name': move.data()['name'],
        'description': move.data()['description'],
        'image': move.data()['imageUrl'],
        'video': move.data()['videoUrl']
      };
    }).toList();

    // Print the upperChestMovesList here to verify that it's populated
    print(bicepMovesList);

    // Call setState here to trigger a rebuild with the updated upperChestMovesList
    setState(() {
      // Update the state if needed
    });
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    getBicepMoves();
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

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
          widget.eObj["name"].toString(),
          style: TextStyle(
              color: TColor.black, fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
      backgroundColor: TColor.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                  color: TColor.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black12,
                        blurRadius: 2,
                        offset: Offset(0, 1))
                  ]),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                "Bicep",
                style: TextStyle(
                    color: TColor.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w700),
              ),
            ),
            ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: bicepMovesList.length,
                itemBuilder: (context, index) {
                  var fObj = bicepMovesList[index] as Map? ?? {};
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MoveView(
                            dObj: fObj,
                            mObj: widget.eObj,
                          ),
                        ),
                      );
                    },
                    child: MoveRow(
                      mObj: fObj,
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
