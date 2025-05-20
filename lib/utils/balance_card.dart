import 'package:flutter/material.dart';

class BalanceCard extends StatelessWidget {
  final String title;
  final String amount;

  const BalanceCard({Key? key, required this.title, required this.amount})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontSize: 12),),
            SizedBox(height: 8,),
            Text(amount, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
          ],
        ),
      ),
    );
  }
}
