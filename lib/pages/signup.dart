import 'package:barberapp/pages/bottomdev.dart';
import 'package:barberapp/pages/login.dart';
import 'package:barberapp/services/database.dart';
import 'package:barberapp/services/sharedprefernce.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:random_string/random_string.dart';
//import 'package:pages/login.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  String email = "", password = "", name = "";
  TextEditingController namecontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController mailcontroller = TextEditingController();

  registration() async {
    if (passwordcontroller.text != "" &&
        namecontroller.text != "" &&
        mailcontroller.text != "") {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        String Id = randomAlphaNumeric(10);
        Map<String, dynamic> userInfoMap = {
          "Name": namecontroller.text,
          "Email": mailcontroller.text,
          "Id": Id,
        };

        await userCredential.user!.updateDisplayName(name);
        await userCredential.user!.reload();
        await DatabaseMethods().addUserInfo(userInfoMap, Id);
        await SharedprefernceHelper().saveUserId(Id);
        await SharedprefernceHelper().saveUserName(namecontroller.text);
        await SharedprefernceHelper().saveUserId(mailcontroller.text);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              "Regisered Successfully",
              style: TextStyle(fontSize: 20),
            ),
          ),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff172ca2),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: IntrinsicHeight(
            child: Container(
              margin: EdgeInsets.only(top: 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Column(
                      children: [
                        Text(
                          "Hello...!",
                          style: GoogleFonts.pacifico(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 45,
                          ),
                        ),

                        SizedBox(height: 80),
                        Container(
                          height: 55,
                          decoration: BoxDecoration(
                            color: const Color(0xff4c5aa5),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Center(
                            child: TextField(
                              controller: namecontroller,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                              ), // ✅ text color white
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                prefixIcon: const Icon(
                                  Icons.person,
                                  color: Colors.white,
                                ), // ✅ white icon
                                hintText: "Name",
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
                          child: Center(
                            child: TextField(
                              controller: mailcontroller,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                                color: Colors.white,
                              ), // ✅ text color white
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                prefixIcon: const Icon(
                                  Icons.person,
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
                          child: Center(
                            child: TextField(
                              obscureText: true,
                              controller: passwordcontroller,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                              ), // ✅ text color white
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                prefixIcon: const Icon(
                                  Icons.password,
                                  color: Colors.white,
                                ), // ✅ white icon
                                hintText: "Password",
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
                        // SizedBox(height: 30),
                        // Container(
                        //   height: 55,
                        //   decoration: BoxDecoration(
                        //     color: const Color(0xff4c5aa5),
                        //     borderRadius: BorderRadius.circular(30),
                        //   ),
                        //   child: Center(
                        //     child: TextField(
                        //       style: const TextStyle(
                        //         color: Colors.white,
                        //       ), // ✅ text color white
                        //       decoration: InputDecoration(
                        //         border: InputBorder.none,
                        //         prefixIcon: const Icon(
                        //           Icons.password,
                        //           color: Colors.white,
                        //         ), // ✅ white icon
                        //         hintText: "Confirm Password",
                        //         hintStyle: const TextStyle(
                        //           color: Colors.white70,
                        //         ), // ✅ white hint
                        //         contentPadding: const EdgeInsets.symmetric(
                        //           vertical: 11,
                        //         ), // ✅ centered text vertically
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        SizedBox(height: 50),
                        GestureDetector(
                          onTap: () {
                            if (mailcontroller.text != "" &&
                                namecontroller.text != "" &&
                                passwordcontroller.text != "") {
                              setState(() {
                                name = namecontroller.text;
                                email = mailcontroller.text;
                                password = passwordcontroller.text;
                              });
                              registration();
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
                                  "Signup",
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
                      ],
                    ),
                  ),
                  SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account",
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
                            MaterialPageRoute(builder: (context) => Login()),
                          );
                        },
                        child: Text(
                          " Login ",
                          style: TextStyle(
                            color: Color(0xfff85f3c),
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                  //SizedBox(height: 20),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset("images/redcircle.png", height: 200),
                      Image.asset("images/yellowcircle.png", height: 200),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
