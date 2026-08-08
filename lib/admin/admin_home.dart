//import 'package:barberapp/admin/admin_bookings.dart';
import 'package:barberapp/admin/admin_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  int currentIndex = 0;

  final Color darkGreen = const Color(0xff2c3925);
  final Color cream = const Color(0xfffdece7);
  final Color orange = const Color(0xfff85f3c);

  @override
  Widget build(BuildContext context) {
    final pages = [
      const AdminDashboard(),
      //const AdminBookingsPage(),
      const AdminProfilePage(),
    ];

    return Scaffold(
      backgroundColor: cream,
      body: pages[currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 15,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          backgroundColor: Colors.white,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: darkGreen,
          unselectedItemColor: Colors.grey,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_outlined),
              activeIcon: Icon(Icons.dashboard),
              label: "Dashboard",
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: "Profile",
            ),
          ],
        ),
      ),
    );
  }
}

// ================================================================
// ADMIN DASHBOARD
// ================================================================

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  Color get darkGreen => const Color(0xff2c3925);
  Color get cream => const Color(0xfffdece7);
  Color get orange => const Color(0xfff85f3c);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    final adminName = user?.displayName?.trim().isNotEmpty == true
        ? user!.displayName!
        : "Admin";

    return SafeArea(
      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection("bookings").snapshots(),
        builder: (context, snapshot) {
          final bookings = snapshot.data?.docs ?? [];

          final now = DateTime.now();

          // ---------------------------------------------------------
          // TOTAL BOOKINGS
          // ---------------------------------------------------------

          final totalBookings = bookings.length;

          // ---------------------------------------------------------
          // TODAY'S BOOKINGS
          // ---------------------------------------------------------

          final todayBookings = bookings.where((doc) {
            final data = doc.data();
            final rawDate = data["date"];

            DateTime? bookingDate;

            if (rawDate is Timestamp) {
              bookingDate = rawDate.toDate();
            }

            if (bookingDate == null) {
              return false;
            }

            return bookingDate.year == now.year &&
                bookingDate.month == now.month &&
                bookingDate.day == now.day;
          }).toList();

          // ---------------------------------------------------------
          // UNIQUE CUSTOMERS
          // ---------------------------------------------------------

          final customerIds = <String>{};

          for (final booking in bookings) {
            final data = booking.data();

            final userId = data["userId"];

            if (userId != null && userId.toString().isNotEmpty) {
              customerIds.add(userId.toString());
            }
          }

          final totalCustomers = customerIds.length;

          // ---------------------------------------------------------
          // SERVICES
          // ---------------------------------------------------------

          final serviceCounts = <String, int>{};

          for (final booking in bookings) {
            final data = booking.data();

            final service =
                (data["service"] ?? data["serviceName"] ?? "Unknown Service")
                    .toString();

            serviceCounts[service] = (serviceCounts[service] ?? 0) + 1;
          }

          String mostPopularService = "No bookings";

          if (serviceCounts.isNotEmpty) {
            mostPopularService = serviceCounts.entries
                .reduce((a, b) => a.value >= b.value ? a : b)
                .key;
          }

          // ---------------------------------------------------------
          // RECENT BOOKINGS
          // ---------------------------------------------------------

          final recentBookings = [...bookings];

          recentBookings.sort((a, b) {
            final aCreated = a.data()["createdAt"];
            final bCreated = b.data()["createdAt"];

            DateTime getDate(dynamic value) {
              if (value is Timestamp) {
                return value.toDate();
              }

              return DateTime.fromMillisecondsSinceEpoch(0);
            }

            return getDate(bCreated).compareTo(getDate(aCreated));
          });

          return RefreshIndicator(
            color: darkGreen,
            onRefresh: () async {
              await FirebaseFirestore.instance.collection("bookings").get();
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(18, 15, 18, 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // =================================================
                  // HEADER
                  // =================================================
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "GOOD DAY 👋",
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                            ),
                          ),

                          const SizedBox(height: 5),

                          Text(
                            adminName,
                            style: TextStyle(
                              color: darkGreen,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 4),

                          const Text(
                            "Here's your shop overview",
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                        ],
                      ),

                      Container(
                        height: 52,
                        width: 52,
                        decoration: BoxDecoration(
                          color: darkGreen,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.content_cut,
                          color: Colors.white,
                          size: 26,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  // =================================================
                  // MAIN BANNER
                  // =================================================
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: darkGreen,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: darkGreen.withOpacity(0.18),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "TODAY'S APPOINTMENTS",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                ),
                              ),

                              const SizedBox(height: 8),

                              Text(
                                "${todayBookings.length}",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 42,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 4),

                              const Text(
                                "appointments scheduled today",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),

                        Container(
                          height: 75,
                          width: 75,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.12),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.calendar_today,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 22),

                  // =================================================
                  // STAT CARDS
                  // =================================================
                  Row(
                    children: [
                      Expanded(
                        child: _statCard(
                          icon: Icons.calendar_month,
                          title: "Bookings",
                          value: totalBookings.toString(),
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: _statCard(
                          icon: Icons.people,
                          title: "Customers",
                          value: totalCustomers.toString(),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: _statCard(
                          icon: Icons.cut,
                          title: "Popular",
                          value: mostPopularService,
                          smallValue: true,
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: _statCard(
                          icon: Icons.trending_up,
                          title: "Today",
                          value: todayBookings.length.toString(),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  // =================================================
                  // RECENT BOOKINGS
                  // =================================================
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Recent Bookings",
                        style: TextStyle(
                          color: darkGreen,
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      TextButton(
                        onPressed: () {
                          // Bottom navigation handles
                          // the full bookings screen.
                        },
                        child: Text(
                          "VIEW ALL",
                          style: TextStyle(
                            color: orange,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  if (recentBookings.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(30),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.calendar_today_outlined,
                            size: 42,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            "No bookings yet",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            "Customer appointments will appear here.",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                  else
                    ...recentBookings
                        .take(5)
                        .map((doc) => _bookingCard(doc.data())),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ==============================================================
  // STAT CARD
  // ==============================================================

  Widget _statCard({
    required IconData icon,
    required String title,
    required String value,
    bool smallValue = false,
  }) {
    return Container(
      height: 155,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black.withOpacity(0.04)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon
          Container(
            height: 38,
            width: 38,
            decoration: BoxDecoration(
              color: const Color(0xff2c3925).withOpacity(0.09),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(icon, color: const Color(0xff2c3925), size: 20),
          ),

          const SizedBox(height: 10),

          // Title
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.grey, fontSize: 13),
          ),

          const SizedBox(height: 4),

          // Value
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: const Color(0xff2c3925),
              fontSize: smallValue ? 16 : 25,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // ==============================================================
  // BOOKING CARD
  // ==============================================================

  Widget _bookingCard(Map<String, dynamic> data) {
    final service = (data["service"] ?? data["serviceName"] ?? "Service")
        .toString();

    final customer = (data["customerName"] ?? "Customer").toString();

    final time = (data["time"] ?? "Time not set").toString();

    final rawDate = data["date"];

    DateTime? date;

    if (rawDate is Timestamp) {
      date = rawDate.toDate();
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          // Service icon
          Container(
            height: 52,
            width: 52,
            decoration: BoxDecoration(
              color: darkGreen,
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Icon(Icons.content_cut, color: Colors.white, size: 23),
          ),

          const SizedBox(width: 13),

          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  service.toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: darkGreen,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  customer,
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),

                const SizedBox(height: 3),

                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      size: 12,
                      color: Colors.grey,
                    ),

                    const SizedBox(width: 4),

                    Text(
                      date == null
                          ? "Date unavailable"
                          : DateFormat("d MMM").format(date),
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),

                    const SizedBox(width: 10),

                    const Icon(Icons.access_time, size: 12, color: Colors.grey),

                    const SizedBox(width: 4),

                    Text(
                      time,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Status
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.10),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              "BOOKED",
              style: TextStyle(
                color: Colors.green,
                fontSize: 9,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
