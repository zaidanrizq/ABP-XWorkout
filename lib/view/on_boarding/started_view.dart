import 'package:xworkout/common/color_extension.dart';
import 'package:xworkout/common_widget/round_button.dart';
import 'package:xworkout/view/login/signup_view.dart';
import 'package:xworkout/view/login/login_view.dart';
import 'package:flutter/material.dart';

class StartedView extends StatefulWidget {
  const StartedView({super.key});

  @override
  State<StartedView> createState() => _StartedViewState();
}

class _StartedViewState extends State<StartedView> {
  bool isChangeColor = false;

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: TColor.white,
      body: Container(
          width: media.width,
          decoration: BoxDecoration(
            gradient: isChangeColor
                ? LinearGradient(
                    colors: TColor.primaryG,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight)
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "XWorkout",
                style: TextStyle(
                    color: TColor.black,
                    fontSize: 36,
                    fontWeight: FontWeight.w700),
              ),
              Text(
                "Everybody Can Train",
                style: TextStyle(
                  color: TColor.gray,
                  fontSize: 18,
                ),
              ),
              SafeArea(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 15),
                      child: RoundButton(
                        title: "Get Started",
                        type: isChangeColor
                            ? RoundButtonType.textGradient
                            : RoundButtonType.bgGradient,
                        onPressed: () {
                          if (isChangeColor) {
                            //GO Next Screen
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SignUpView()));
                          } else {
                            //Change Color
                            setState(() {
                              isChangeColor = true;
                            });
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 15),
                      child: RoundButton(
                        title: "Log In",
                        type: isChangeColor
                            ? RoundButtonType.textGradient
                            : RoundButtonType.bgGradient,
                        onPressed: () {
                          if (isChangeColor) {
                            //GO Next Screen
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginView()));
                          } else {
                            //Change Color
                            setState(() {
                              isChangeColor = true;
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
              )
            ],
          )),
    );
  }
}
