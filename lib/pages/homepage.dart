import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final String name;
  final String phone;

  HomePage({required this.name, required this.phone});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Zybomart Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome, $name!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text('Phone: $phone', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
