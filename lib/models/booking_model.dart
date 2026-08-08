import 'package:cloud_firestore/cloud_firestore.dart';

class BookingModel {
  final String id;
  final String serviceName;
  final DateTime date;
  final String time;

  BookingModel({
    this.id = '',
    required this.serviceName,
    required this.date,
    required this.time,
  });

  factory BookingModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? {};

    final rawDate = data['date'];
    DateTime parsedDate;

    if (rawDate is Timestamp) {
      parsedDate = rawDate.toDate();
    } else if (rawDate is DateTime) {
      parsedDate = rawDate;
    } else {
      parsedDate = DateTime.tryParse(rawDate?.toString() ?? '') ??
          DateTime.now();
    }

    return BookingModel(
      id: doc.id,
      serviceName: (data['service'] ?? data['serviceName'] ?? '').toString(),
      date: parsedDate,
      time: (data['time'] ?? '').toString(),
    );
  }
}
