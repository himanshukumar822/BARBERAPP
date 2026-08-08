import 'package:barberapp/admin/admin_home.dart';
import 'package:barberapp/pages/home.dart';
import 'package:barberapp/pages/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:barberapp/pages/bottomdev.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  Future<Widget> _getStartPage(User user) async {
    try {
      final document = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      final data = document.data();

      final String role = (data?['role'] ?? 'customer')
          .toString()
          .toLowerCase();

      if (role == 'admin') {
        return const AdminHome();
      }

      return const Bottomdev();
    } catch (e) {
      // If the role cannot be read, treat the account as a customer.
      return const Home();
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Firebase is checking the current authentication state.
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Color(0xfffdece7),
            body: Center(
              child: CircularProgressIndicator(color: Color(0xff2c3925)),
            ),
          );
        }

        // ----------------------------------------------------------
        // NOT LOGGED IN
        // ----------------------------------------------------------

        if (!snapshot.hasData) {
          return const Login();
        }

        // ----------------------------------------------------------
        // ALREADY LOGGED IN
        // ----------------------------------------------------------

        final User user = snapshot.data!;

        return FutureBuilder<Widget>(
          future: _getStartPage(user),
          builder: (context, roleSnapshot) {
            if (roleSnapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                backgroundColor: Color(0xfffdece7),
                body: Center(
                  child: CircularProgressIndicator(color: Color(0xff2c3925)),
                ),
              );
            }

            if (roleSnapshot.hasError || !roleSnapshot.hasData) {
              return const Home();
            }

            return roleSnapshot.data!;
          },
        );
      },
    );
  }
}
