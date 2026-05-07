import 'package:barberapp/pages/login.dart';
import 'package:barberapp/services/widget_suppart.dart';
import 'package:flutter/material.dart';
import 'package:barberapp/admin/adminlogin.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});
  @override
  State<Onboarding> createState() {
    return _OnboardingState();
  }
}

class _OnboardingState extends State<Onboarding> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Image.asset("images/barber.png"),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(color: Color(0xff2c3925)),
                child: Column(
                  //mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 30.0),
                    Text(
                      "Welcome To My App lorem iposm is a dummy text of the printing and tyo setting industry",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color.fromARGB(180, 255, 255, 255),

                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 30.0),
                    Material(
                      elevation: 5.0,
                      borderRadius: BorderRadius.circular(10),

                      child: Container(
                        height: 60,
                        width: 250,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Color(0xfffdece7),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            // 👇 Navigate to the Booking Page
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Login(),
                              ),
                            );
                          },
                          child: Center(
                            child: Text(
                              "BOOK NOW",
                              style: AppWidget.healingTextStyle(22.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),

                    Material(
                      elevation: 5.0,
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        height: 60,
                        width: 250,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AdminLogin(),
                              ),
                            );
                          },
                          child: Center(
                            child: Text(
                              "ADMIN PANEL",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
