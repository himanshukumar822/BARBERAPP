// ignore_for_file: use_build_context_synchronously

import 'package:barberapp/admin/admin_home.dart';
import 'package:barberapp/pages/bottomdev.dart';
import 'package:barberapp/pages/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// IMPORTANT:
// When you send me your admin panel file, I will add its import here.
// For example:
// import 'package:barberapp/pages/admin_page.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController passwordcontroller = TextEditingController();

  final TextEditingController mailcontroller = TextEditingController();

  bool isLoading = false;

  // ============================================================
  // LOGIN
  // ============================================================

  Future<void> userLogin() async {
    final email = mailcontroller.text.trim();
    final password = passwordcontroller.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            "Please enter your email and password",
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      // ----------------------------------------------------------
      // 1. Login using Firebase Authentication
      // ----------------------------------------------------------

      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      final User? user = userCredential.user;

      if (user == null) {
        throw Exception("Could not get logged-in user.");
      }

      // ----------------------------------------------------------
      // 2. Get the user's Firebase UID
      // ----------------------------------------------------------

      final String uid = user.uid;

      // ----------------------------------------------------------
      // 3. Look for this user in Firestore
      // ----------------------------------------------------------

      final DocumentSnapshot<Map<String, dynamic>> userDocument =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      // ----------------------------------------------------------
      // 4. Check the role
      // ----------------------------------------------------------

      final Map<String, dynamic>? userData = userDocument.data();

      final String role = (userData?['role'] ?? 'customer')
          .toString()
          .toLowerCase();

      if (!mounted) return;

      // ----------------------------------------------------------
      // 5. ADMIN
      // ----------------------------------------------------------

      if (role == 'admin') {
        /*
          IMPORTANT:

          Replace the code below with your actual Admin Panel page.

          For example, if your admin page is:

          lib/pages/admin_page.dart

          and contains:

          class AdminPage extends StatelessWidget

          then add:

          import 'package:barberapp/pages/admin_page.dart';

          at the top and use:

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const AdminPage(),
            ),
          );
        */

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              "Admin login successful",
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        );

        // TEMPORARY:
        // We will replace this with your real Admin Panel
        // after you send me its code/file.
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const AdminHome()),
        );

        return;
      }

      // ----------------------------------------------------------
      // 6. CUSTOMER
      // ----------------------------------------------------------

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const Bottomdev()),
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      String message;

      switch (e.code) {
        case 'user-not-found':
          message = "No account found with this email.";
          break;

        case 'wrong-password':
          message = "Incorrect password.";
          break;

        case 'invalid-credential':
          message = "Incorrect email or password.";
          break;

        case 'invalid-email':
          message = "Please enter a valid email address.";
          break;

        case 'user-disabled':
          message = "This account has been disabled.";
          break;

        case 'too-many-requests':
          message = "Too many attempts. Please try again later.";
          break;

        default:
          message = e.message ?? "Login failed. Please try again.";
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
    } on FirebaseException catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            "Could not check account: ${e.message ?? e.code}",
            style: const TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            "Something went wrong: $e",
            style: const TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    passwordcontroller.dispose();
    mailcontroller.dispose();
    super.dispose();
  }

  // ============================================================
  // UI
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff172ca2),
      // ignore: avoid_unnecessary_containers
      body: Container(
        child: Stack(
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
                    // ------------------------------------------------
                    // WELCOME
                    // ------------------------------------------------
                    Text(
                      "Welcome \nBack",
                      style: GoogleFonts.pacifico(
                        color: Colors.white,
                        fontSize: 40.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    // ------------------------------------------------
                    // EMAIL
                    // ------------------------------------------------
                    Container(
                      height: 55,
                      decoration: BoxDecoration(
                        color: const Color(0xff4c5aa5),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Center(
                        child: TextField(
                          controller: mailcontroller,
                          keyboardType: TextInputType.emailAddress,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            prefixIcon: Icon(Icons.email, color: Colors.white),
                            hintText: "Email",
                            hintStyle: TextStyle(color: Colors.white70),
                            contentPadding: EdgeInsets.symmetric(vertical: 11),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // ------------------------------------------------
                    // PASSWORD
                    // ------------------------------------------------
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

                    // ------------------------------------------------
                    // FORGOT PASSWORD
                    // ------------------------------------------------
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () async {
                            final email = mailcontroller.text.trim();

                            if (email.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  backgroundColor: Colors.red,
                                  content: Text(
                                    "Enter your email first",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              );
                              return;
                            }

                            try {
                              await FirebaseAuth.instance
                                  .sendPasswordResetEmail(email: email);

                              if (!mounted) return;

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  backgroundColor: Colors.green,
                                  content: Text(
                                    "Password reset email sent",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              );
                            } on FirebaseAuthException catch (e) {
                              if (!mounted) return;

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: Colors.red,
                                  content: Text(
                                    e.message ?? "Could not send reset email",
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              );
                            }
                          },
                          child: const Text(
                            "Forgot Password ?",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 50),

                    // ------------------------------------------------
                    // LOGIN BUTTON
                    // ------------------------------------------------
                    GestureDetector(
                      onTap: isLoading ? null : userLogin,
                      child: Center(
                        child: Container(
                          height: 60,
                          width: 150,
                          decoration: BoxDecoration(
                            color: isLoading
                                ? Colors.grey
                                : const Color(0xfff85f3c),
                            borderRadius: BorderRadius.circular(60),
                          ),
                          child: Center(
                            child: isLoading
                                ? const SizedBox(
                                    height: 26,
                                    width: 26,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 3,
                                    ),
                                  )
                                : const Text(
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

                    const SizedBox(height: 50),

                    // ------------------------------------------------
                    // SIGNUP
                    // ------------------------------------------------
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
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
                              MaterialPageRoute(
                                builder: (context) => const Signup(),
                              ),
                            );
                          },
                          child: const Text(
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

                    const SizedBox(height: 30),
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

// ================================================================
// TEMPORARY ADMIN PAGE
// ================================================================
//
// This is only here so login.dart compiles right now.
// Once you send me your actual admin panel code, I will replace
// this with your real Admin Panel.
// ================================================================
