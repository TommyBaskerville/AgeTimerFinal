import 'package:flutter/material.dart';

class BirthDatePage extends StatefulWidget {
  @override
  _BirthDatePageState createState() => _BirthDatePageState();
}

class _BirthDatePageState extends State<BirthDatePage> {
  final _yearController = TextEditingController();
  final _dayController = TextEditingController();

  @override
  void dispose() {
    _yearController.dispose();
    _dayController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 231, 231, 231),
      appBar: AppBar(
        title: Text('Enter Birth Date'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            SizedBox(height: 50),
            const Text("Welcome to the App!",
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.w500)),
            const SizedBox(height: 50),
            SizedBox(height: 10),
            TextField(
              controller: _yearController,
              decoration: InputDecoration(
                labelText: 'Enter your birth year',
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            TextField(
              controller: _dayController,
              decoration: InputDecoration(
                labelText: 'Enter your birth day',
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 40), 
            ElevatedButton(
              child: Text('Submit'),
              onPressed: () {
                print('Birth Year: ${_yearController.text}');
                print('Birth Day: ${_dayController.text}');
              },
            ),
          ],
        ),
      ),
    );
  }
}