import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:barberapp/pages/booking_page.dart';
import 'package:barberapp/pages/bottomdev.dart';
import 'package:barberapp/models/booking_model.dart';

class BookingPage extends StatefulWidget {
  final String serviceName;

  const BookingPage({super.key, required this.serviceName});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  int selectedIndex = 0;
  late List<DateTime> next7Days;
  String? selectedTime;
  @override
  void initState() {
    super.initState();
    next7Days = List.generate(
      7,
      (index) => DateTime.now().add(Duration(days: index)),
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );

    const darkGreen = Color(0xFF2E3D2F);
    const lightBg = Color(0xFFF4F1DF);
    const accent = Color(0xFFE8DCC6);

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: lightBg,
      body: Stack(
        children: [
          // ===== HEADER BACKGROUND =====
          Container(
            height: 320,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: darkGreen,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(28),
                topRight: Radius.circular(28),
              ),
            ),
          ),

          // ===== CONTENT =====
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.arrow_back, color: Colors.white),
                      //                    leading: IconButton(
                      //   icon: const Icon(Icons.arrow_back),
                      //   onPressed: () {
                      //     Navigator.pop(context); // 👈 goes back to Home
                      //   },
                      // ),
                      const SizedBox(height: 16),

                      Row(
                        children: [
                          CircleAvatar(
                            radius: 32,
                            backgroundImage: const AssetImage(
                              "images/barber1.png",
                            ),
                            backgroundColor: accent,
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "JOHN DOE",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                widget.serviceName,
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),
                      const Text(
                        "CHOOSE YOUR SLOT",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 12),

                      // ===== DATE SELECTOR (REAL DATES) =====
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(next7Days.length, (index) {
                            final date = next7Days[index];
                            final day = DateFormat('EEE').format(date); // Mon
                            final number = DateFormat('d').format(date); // 25
                            final isSelected = selectedIndex == index;

                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedIndex = index;
                                });
                              },
                              child: _dateItem(day, number, isSelected),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),

                // ===== TIME SECTION =====
                Expanded(
                  child: Container(
                    color: lightBg,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Divider(thickness: 3, color: Colors.black),
                        const SizedBox(height: 12),
                        const Text(
                          "CHOOSE YOUR TIME",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 16),

                        Expanded(
                          child: GridView.count(
                            crossAxisCount: 3,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 2.3,
                            children:
                                [
                                  "09:00 AM",
                                  "10:00 AM",
                                  "11:00 AM",
                                  "12:00 PM",
                                  "01:00 PM",
                                  "02:00 PM",
                                  "03:00 PM",
                                  "04:00 PM",
                                  "05:00 PM",
                                  "06:00 PM",
                                  "07:00 PM",
                                  "08:00 PM",
                                  "09:00 PM",
                                ].map((time) {
                                  final isSelected = selectedTime == time;

                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedTime = time;
                                      });
                                    },
                                    child: _TimeChip(
                                      time,
                                      isSelected: isSelected,
                                    ),
                                  );
                                }).toList(),
                          ),
                        ),

                        Center(
                          child: SizedBox(
                            width: 160,
                            height: 56,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: darkGreen,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () {
                                if (selectedTime == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Please select a time"),
                                    ),
                                  );
                                  return;
                                }

                                final selectedDate = next7Days[selectedIndex];
                                // 👇 Switch to Booking tab
                                // Bottomdev.of(context)?.setBookingAndOpenTab(
                                final booking = BookingModel(
                                  serviceName: widget.serviceName,
                                  date: selectedDate,
                                  time: selectedTime!,
                                );

                                // 👇 Close details page
                                Navigator.pop(context, booking);
                              },
                              child: const Text(
                                "BOOK NOW",
                                style: TextStyle(
                                  color: lightBg,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget _dateItem(String day, String date, bool selected) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: selected ? const Color(0xFFE8DCC6) : Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white),
      ),
      child: Column(
        children: [
          Text(
            day,
            style: TextStyle(color: selected ? Colors.black : Colors.white70),
          ),
          const SizedBox(height: 6),
          Text(
            date,
            style: TextStyle(
              color: selected ? Colors.black : Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _TimeChip extends StatelessWidget {
  final String time;
  final bool isSelected;
  const _TimeChip(this.time, {required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF2E3D2F) : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: isSelected ? Colors.black : Colors.black26),
      ),
      child: Text(
        time,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: isSelected ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}
