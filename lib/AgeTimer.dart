import 'package:auth_firebase/InsertAge.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

void main() {
  runApp(const AgeTimerApp());
}

class AgeTimerApp extends StatelessWidget {
  const AgeTimerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Age Timer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AgeTimerPage(),
    );
  }
}

class AgeTimerPage extends StatefulWidget {
  const AgeTimerPage({Key? key}) : super(key: key);

  @override
  _AgeTimerPageState createState() => _AgeTimerPageState();
}

class _AgeTimerPageState extends State<AgeTimerPage> {
  DateTime _birthDate = DateTime.now();
  DateTime _currentTime = DateTime.now();
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _fetchBirthDateFromFirestore();
    _currentTime = DateTime.now();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _fetchBirthDateFromFirestore() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        if (data.containsKey('birthDate')) {
          setState(() {
            _birthDate = (data['birthDate'] as Timestamp).toDate();
          });
        }
      }
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _currentTime = DateTime.now();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Duration age = _currentTime.difference(_birthDate);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Age Timer'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => (BirthDatePage ()),
                )
              );
          },
        ),
      ),
      body: Center(
        child: Text(
          '${age.inDays}:${age.inHours % 24}:${age.inMinutes % 60}:${age.inSeconds % 60}',
          style: const TextStyle(fontSize: 50, color: Color.fromARGB(255, 49, 49, 49)),
        ),
      ),
    );
  }
}
