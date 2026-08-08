import 'package:barberapp/pages/login.dart';
import 'package:barberapp/services/widget_suppart.dart';
import 'package:flutter/material.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            // -------------------------------------------------------
            // TOP IMAGE
            // -------------------------------------------------------
            Image.asset(
              "images/barber.png",
              width: double.infinity,
              fit: BoxFit.cover,
            ),

            // -------------------------------------------------------
            // BOTTOM SECTION
            // -------------------------------------------------------
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                decoration: const BoxDecoration(color: Color(0xff2c3925)),
                child: Column(
                  children: [
                    const SizedBox(height: 30.0),

                    // -------------------------------------------------
                    // WELCOME TEXT
                    // -------------------------------------------------
                    const Text(
                      "Welcome To My App\n"
                      "Book your barber appointment easily.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color.fromARGB(180, 255, 255, 255),
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                    ),

                    const SizedBox(height: 30.0),

                    // -------------------------------------------------
                    // BOOK NOW BUTTON
                    // -------------------------------------------------
                    Material(
                      elevation: 5.0,
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        height: 60,
                        width: 250,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xfffdece7),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: GestureDetector(
                          onTap: () {
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

                    const SizedBox(height: 30.0),

                    // -------------------------------------------------
                    // INFORMATION
                    // -------------------------------------------------
                    const Text(
                      "Already have an account? Login to continue.",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white70, fontSize: 14),
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
