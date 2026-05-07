import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:barberapp/models/booking_model.dart';

class BookingsPage extends StatelessWidget {
  final BookingModel? booking;

  const BookingsPage({super.key, this.booking});

  @override
  Widget build(BuildContext context) {
    const darkGreen = Color(0xff2c3925);
    const lightBg = Color(0xfffdece7);

    return Scaffold(
      backgroundColor: lightBg,
      appBar: AppBar(
        backgroundColor: darkGreen,
        elevation: 0,
        title: const Text(
          "BOOKINGS",
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1),
        ),
        centerTitle: false,
      ),
      body: booking == null
          ? _emptyState()
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _bookingCard(),
                  const SizedBox(height: 8),
                  const Divider(thickness: 1.5),
                ],
              ),
            ),
    );
  }

  Widget _bookingCard() {
    return Container(
      width: double.infinity, // ✅ FULL WIDTH
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xff2c3925), width: 2),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon box
          Container(
            height: 52,
            width: 52,
            decoration: BoxDecoration(
              color: const Color(0xff2c3925),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.content_cut, color: Colors.white),
          ),

          const SizedBox(width: 14),

          // Booking details
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
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 2),
              Text(booking!.time, style: const TextStyle(fontSize: 14)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _emptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.event_busy, size: 80, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            "No bookings yet",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Book a service to see it here",
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
