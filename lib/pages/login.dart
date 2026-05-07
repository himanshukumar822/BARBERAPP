import 'package:barberapp/pages/bottomdev.dart';
import 'package:barberapp/pages/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
//import 'package:loginui/signup.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String email = "", password = "";
  //TextEditingController namecontroller = new TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController mailcontroller = TextEditingController();

  userLogin() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      Navigator.push(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(builder: (context) => Bottomdev()),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              "No user found for that Email",
              style: TextStyle(fontSize: 18.0, color: Colors.white),
            ),
          ),
        );
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              "Wrong Password Provided by User",
              style: TextStyle(fontSize: 18.0, color: Colors.white),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff172ca2),
      body: Container(
        child: Stack(
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Positioned.fill(
              child: Image.asset("images/bg.png", fit: BoxFit.cover),
            ),

            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height / 2.75,
                  left: 20,
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Welcome \n Back",
                      style: GoogleFonts.pacifico(
                        color: Colors.white,
                        fontSize: 40.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      height: 55,
                      decoration: BoxDecoration(
                        color: const Color(0xff4c5aa5),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Center(
                        child: TextField(
                          controller: mailcontroller,
                          style: const TextStyle(
                            color: Colors.white,
                          ), // ✅ text color white
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            prefixIcon: const Icon(
                              Icons.email,
                              color: Colors.white,
                            ), // ✅ white icon
                            hintText: "Email",
                            hintStyle: const TextStyle(
                              color: Colors.white70,
                            ), // ✅ white hint
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 11,
                            ), // ✅ centered text vertically
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    Container(
                      height: 55,
                      decoration: BoxDecoration(
                        color: const Color(0xff4c5aa5),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: TextField(
                        controller: passwordcontroller,
                        obscureText: true, // ✅ hides password
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: const Icon(
                            Icons.lock,
                            color: Colors.white,
                          ),
                          hintText: "Password",
                          hintStyle: const TextStyle(color: Colors.white70),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 11,
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.end, // ✅ aligns to right
                      children: [
                        TextButton(
                          onPressed: () {
                            // TODO: add forgot password action here
                          },
                          child: const Text(
                            "Forgot Password ?",
                            style: TextStyle(
                              color: Colors.white, // ✅ white text
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 50),
                    GestureDetector(
                      onTap: () async {
                        if (mailcontroller.text != "" &&
                            passwordcontroller.text != "") {
                          setState(() {
                            email = mailcontroller.text;
                            password = passwordcontroller.text;
                          });
                          userLogin();
                        }
                      },
                      child: Center(
                        child: Container(
                          height: 60,
                          decoration: BoxDecoration(
                            color: Color(0xfff85f3c),
                            borderRadius: BorderRadius.circular(60),
                          ),
                          width: 150,
                          child: Center(
                            child: Text(
                              "Login",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 24.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "New User ?",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 15.0,
                          ),
                        ),

                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Signup()),
                            );
                          },
                          child: Text(
                            " Signup ",
                            style: TextStyle(
                              color: Color(0xfff85f3c),
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                      ],
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
