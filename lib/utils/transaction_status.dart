import 'package:flutter/material.dart';

class TransactionStatus extends StatelessWidget {
  final IconData icon;
  final String label;

  const TransactionStatus({Key? key, required this.icon, required this.label})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [Icon(icon, size: 32), SizedBox(height: 8), Text(label)],
    );
  }
}
