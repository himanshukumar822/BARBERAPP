import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:barberapp/models/booking_model.dart';

class BookingsTab extends StatelessWidget {
  final BookingModel? booking;

  const BookingsTab({super.key, this.booking});

  @override
  Widget build(BuildContext context) {
    const darkGreen = Color(0xff2c3925);
    const lightBg = Color(0xfffdece7);

    return Scaffold(
      backgroundColor: lightBg,
      appBar: AppBar(
        backgroundColor: darkGreen,
        title: const Text(
          "BOOKINGS",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      body: booking == null
          ? const Center(
              child: Text(
                "No bookings yet",
                style: TextStyle(fontSize: 20, color: Colors.grey),
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Container(
                  width: double.infinity, // 🔥 THIS IS CRITICAL
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: darkGreen, width: 2),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Icon
                      Container(
                        height: 52,
                        width: 52,
                        decoration: BoxDecoration(
                          color: darkGreen,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.content_cut,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(width: 14),

                      // Text
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            booking!.serviceName.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            DateFormat('EEE, d MMM yyyy').format(booking!.date),
                          ),
                          Text(booking!.time),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
