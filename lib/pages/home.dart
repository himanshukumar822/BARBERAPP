import 'package:barberapp/models/booking_model.dart';
import 'package:barberapp/pages/booking_page.dart';
import 'package:barberapp/pages/details_page.dart';
import 'package:barberapp/services/widget_suppart.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:barberapp/pages/bottomdev.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String userName = "";

  @override
  void initState() {
    super.initState();
    getUserName();
  }

  getUserName() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Priority 1: displayName (if you set it during signup)
      if (user.displayName != null && user.displayName!.isNotEmpty) {
        userName = user.displayName!;
      }
      // Priority 2: email prefix (safe fallback)
      else if (user.email != null) {
        userName = user.email!.split('@').first;
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff2c3925),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "HELLO",
                      style: TextStyle(
                        color: Color(0xfffdece7),
                        fontSize: 22.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    Text(
                      userName.isEmpty
                          ? ""
                          : userName.split(" ").first.toUpperCase(),
                      style: TextStyle(
                        color: Color(0xfffdece7),
                        fontSize: 40.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 120),
                      child: Divider(color: Color(0xfffdece7), thickness: 4.0),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Fresh fades,clean cuts\nYour style,just one tap away",
                      //textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color.fromARGB(180, 255, 255, 255),

                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.0),
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(color: Color(0xfffdece7)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Divider(color: Color(0xff2c3925), thickness: 8.0),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Text(
                        "SERVICES",
                        style: AppWidget.greenTextStyle(26.0),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: GestureDetector(
                        onTap: () async {
                          final booking = await Navigator.of(context)
                              .push<BookingModel>(
                                MaterialPageRoute(
                                  builder: (_) => const BookingPage(
                                    serviceName: "Hair Cut",
                                  ),
                                ),
                              );
                          if (booking != null) {
                            Bottomdev.of(
                              context,
                            )?.setBookingAndOpenTab(booking);
                          }
                        },
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: Color(0xfffdece7),
                                border: Border.all(
                                  color: Color(0xff2c3925),
                                  width: 7.0,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Container(
                                padding: EdgeInsets.all(18),
                                decoration: BoxDecoration(
                                  color: Color(0xff2c3925),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Image.asset(
                                  "images/scissors.png",
                                  height: 50,
                                  width: 50,
                                  fit: BoxFit.cover,
                                  color: Color(0xfffdece7),
                                ),
                              ),
                            ),
                            SizedBox(width: 20.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "HAIR CUT",
                                  style: AppWidget.greenTextStyle(24.0),
                                ),
                                Text(
                                  "Welcome To My App lorem iposm \n is a dummy text of the printing ",

                                  style: TextStyle(
                                    color: Color(0xff2c3925),

                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Divider(color: Color(0xff2c3925), thickness: 4.0),
                    ),
                    SizedBox(height: 10.0),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: GestureDetector(
                        onTap: () async {
                          final booking = await Navigator.of(context)
                              .push<BookingModel>(
                                MaterialPageRoute(
                                  builder: (_) =>
                                      const BookingPage(serviceName: "SHAIVNG"),
                                ),
                              );
                          if (booking != null) {
                            Bottomdev.of(
                              context,
                            )?.setBookingAndOpenTab(booking);
                          }
                        },
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: Color(0xfffdece7),
                                border: Border.all(
                                  color: Color(0xff2c3925),
                                  width: 7.0,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Container(
                                padding: EdgeInsets.all(18),
                                decoration: BoxDecoration(
                                  color: Color(0xff2c3925),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Image.asset(
                                  "images/razor.png",
                                  height: 50,
                                  width: 50,
                                  fit: BoxFit.cover,
                                  color: Color(0xfffdece7),
                                ),
                              ),
                            ),
                            SizedBox(width: 20.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "SHAVING",
                                  style: AppWidget.greenTextStyle(24.0),
                                ),
                                Text(
                                  "Welcome To My App lorem iposm \n is a dummy text of the printing ",

                                  style: TextStyle(
                                    color: Color(0xff2c3925),

                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Divider(color: Color(0xff2c3925), thickness: 4.0),
                    ),
                    SizedBox(height: 10.0),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: GestureDetector(
                        onTap: () async {
                          final booking = await Navigator.of(context)
                              .push<BookingModel>(
                                MaterialPageRoute(
                                  builder: (_) => const BookingPage(
                                    serviceName: "CREAMBATH",
                                  ),
                                ),
                              );
                          if (booking != null) {
                            Bottomdev.of(
                              context,
                            )?.setBookingAndOpenTab(booking);
                          }
                        },
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: Color(0xfffdece7),
                                border: Border.all(
                                  color: Color(0xff2c3925),
                                  width: 7.0,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Container(
                                padding: EdgeInsets.all(18),
                                decoration: BoxDecoration(
                                  color: Color(0xff2c3925),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Image.asset(
                                  "images/lotion.png",
                                  height: 50,
                                  width: 50,
                                  fit: BoxFit.cover,
                                  color: Color(0xfffdece7),
                                ),
                              ),
                            ),
                            SizedBox(width: 20.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "CRAEMBATH",
                                  style: AppWidget.greenTextStyle(24.0),
                                ),
                                Text(
                                  "Welcome To My App lorem iposm \n is a dummy text of the printing ",

                                  style: TextStyle(
                                    color: Color(0xff2c3925),

                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Divider(color: Color(0xff2c3925), thickness: 4.0),
                    ),
                    SizedBox(height: 10.0),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: GestureDetector(
                        onTap: () async {
                          final booking = await Navigator.of(context)
                              .push<BookingModel>(
                                MaterialPageRoute(
                                  builder: (_) => const BookingPage(
                                    serviceName: "HAIR COLORING",
                                  ),
                                ),
                              );
                          if (booking != null) {
                            Bottomdev.of(
                              context,
                            )?.setBookingAndOpenTab(booking);
                          }
                        },
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: Color(0xfffdece7),
                                border: Border.all(
                                  color: Color(0xff2c3925),
                                  width: 7.0,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Container(
                                padding: EdgeInsets.all(18),
                                decoration: BoxDecoration(
                                  color: Color(0xff2c3925),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Image.asset(
                                  "images/hair-color.png",
                                  height: 50,
                                  width: 50,
                                  fit: BoxFit.cover,
                                  color: Color(0xfffdece7),
                                ),
                              ),
                            ),
                            SizedBox(width: 20.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "HAIR COLORING",
                                  style: AppWidget.greenTextStyle(24.0),
                                ),
                                Text(
                                  "Welcome To My App lorem iposm \n is a dummy text of the printing ",

                                  style: TextStyle(
                                    color: Color(0xff2c3925),

                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Divider(color: Color(0xff2c3925), thickness: 4.0),
                    ),
                    SizedBox(height: 10.0),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: GestureDetector(
                        onTap: () async {
                          final booking = await Navigator.of(context)
                              .push<BookingModel>(
                                MaterialPageRoute(
                                  builder: (_) => const BookingPage(
                                    serviceName: "HAIR COLORING",
                                  ),
                                ),
                              );
                          if (booking != null) {
                            Bottomdev.of(
                              context,
                            )?.setBookingAndOpenTab(booking);
                          }
                        },
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: Color(0xfffdece7),
                                border: Border.all(
                                  color: Color(0xff2c3925),
                                  width: 7.0,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Container(
                                padding: EdgeInsets.all(18),
                                decoration: BoxDecoration(
                                  color: Color(0xff2c3925),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Image.asset(
                                  "images/hair-color.png",
                                  height: 50,
                                  width: 50,
                                  fit: BoxFit.cover,
                                  color: Color(0xfffdece7),
                                ),
                              ),
                            ),
                            SizedBox(width: 20.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "HAIR COLORING",
                                  style: AppWidget.greenTextStyle(24.0),
                                ),
                                Text(
                                  "Welcome To My App lorem iposm \n is a dummy text of the printing ",

                                  style: TextStyle(
                                    color: Color(0xff2c3925),

                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Divider(color: Color(0xff2c3925), thickness: 4.0),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
