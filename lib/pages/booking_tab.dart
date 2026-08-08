import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:barberapp/models/booking_model.dart';

class BookingsTab extends StatelessWidget {
  const BookingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    const darkGreen = Color(0xff2c3925);
    const lightBg = Color(0xfffdece7);

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(
        backgroundColor: lightBg,
        body: Center(
          child: Text("Please login to see your bookings"),
        ),
      );
    }

    return Scaffold(
      backgroundColor: lightBg,
      appBar: AppBar(
        backgroundColor: darkGreen,
        title: const Text(
          "BOOKINGS",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection("bookings")
            .where("userId", isEqualTo: user.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  "Unable to load bookings.\n${snapshot.error}",
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final docs = [...(snapshot.data?.docs ?? [])];

          if (docs.isEmpty) {
            return const Center(
              child: Text(
                "No bookings yet",
                style: TextStyle(fontSize: 20, color: Colors.grey),
              ),
            );
          }

          // Sort locally so Firestore does not require a composite index.
          docs.sort((a, b) {
            final aCreated = a.data()["createdAt"];
            final bCreated = b.data()["createdAt"];

            DateTime toDate(dynamic value) {
              if (value is Timestamp) return value.toDate();
              return DateTime.fromMillisecondsSinceEpoch(0);
            }

            return toDate(bCreated).compareTo(toDate(aCreated));
          });

          final bookings = docs
              .map((doc) => BookingModel.fromFirestore(doc))
              .toList();

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: bookings.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              return _bookingCard(bookings[index], darkGreen);
            },
          );
        },
      ),
    );
  }

  Widget _bookingCard(BookingModel booking, Color darkGreen) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: darkGreen, width: 2),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 52,
            width: 52,
            decoration: BoxDecoration(
              color: darkGreen,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.content_cut, color: Colors.white),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  booking.serviceName.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  DateFormat('EEE, d MMM yyyy').format(booking.date),
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 2),
                Text(
                  booking.time,
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
