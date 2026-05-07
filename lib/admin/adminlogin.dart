import 'package:barberapp/admin/admin_home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminLogin extends StatefulWidget {
  const AdminLogin({super.key});

  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  String email = "", password = "";

  TextEditingController mailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();

  adminLogin() async {
    try {
      // 1. Login using Firebase Auth
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      // 2. Get UID
      String uid = userCredential.user!.uid;

      // 3. Read user document from Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .get();

      // 4. Check if user document exists
      if (!userDoc.exists) {
        await FirebaseAuth.instance.signOut();
        throw "User data not found";
      }

      // 5. Check role
      String role = userDoc["role"];

      if (role != "admin") {
        await FirebaseAuth.instance.signOut();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              "Access denied. You are not an admin.",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        );
        return;
      }

      // 6. Admin confirmed → open admin panel
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AdminHome()),
      );
    } on FirebaseAuthException catch (e) {
      String message = "Login failed";

      if (e.code == 'user-not-found') {
        message = "Admin not found";
      } else if (e.code == 'wrong-password') {
        message = "Wrong password";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            message,
            style: const TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            e.toString(),
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff172ca2),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset("images/bg.png", fit: BoxFit.cover),
          ),

          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height / 2.75,
                left: 20,
                right: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Admin \n Login",
                    style: GoogleFonts.pacifico(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // EMAIL
                  Container(
                    height: 55,
                    decoration: BoxDecoration(
                      color: const Color(0xff4c5aa5),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: TextField(
                      controller: mailcontroller,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.email, color: Colors.white),
                        hintText: "Admin Email",
                        hintStyle: TextStyle(color: Colors.white70),
                        contentPadding: EdgeInsets.symmetric(vertical: 11),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // PASSWORD
                  Container(
                    height: 55,
                    decoration: BoxDecoration(
                      color: const Color(0xff4c5aa5),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: TextField(
                      controller: passwordcontroller,
                      obscureText: true,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.lock, color: Colors.white),
                        hintText: "Password",
                        hintStyle: TextStyle(color: Colors.white70),
                        contentPadding: EdgeInsets.symmetric(vertical: 11),
                      ),
                    ),
                  ),

                  const SizedBox(height: 50),

                  // LOGIN BUTTON
                  GestureDetector(
                    onTap: () {
                      if (mailcontroller.text.isNotEmpty &&
                          passwordcontroller.text.isNotEmpty) {
                        setState(() {
                          email = mailcontroller.text;
                          password = passwordcontroller.text;
                        });
                        adminLogin();
                      }
                    },
                    child: Center(
                      child: Container(
                        height: 60,
                        width: 160,
                        decoration: BoxDecoration(
                          color: const Color(0xfff85f3c),
                          borderRadius: BorderRadius.circular(60),
                        ),
                        child: const Center(
                          child: Text(
                            "Admin Login",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // BACK TO CUSTOMER
                  Center(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        "Back to Customer Login",
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
