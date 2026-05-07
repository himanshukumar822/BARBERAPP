import 'package:flutter/material.dart';

class PaymentPage extends StatelessWidget {
  final String serviceName;
  final DateTime date;
  final String time;

  const PaymentPage({
    super.key,
    required this.serviceName,
    required this.date,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Payment")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Service: $serviceName"),
            Text("Date: ${date.toLocal()}"),
            Text("Time: $time"),
            const SizedBox(height: 20),
            const Text("Stripe payment goes here"),
          ],
        ),
      ),
    );
  }
}
