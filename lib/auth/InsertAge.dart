import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Importa el paquete de Firebase Authentication
import 'package:cloud_firestore/cloud_firestore.dart'; // Importa el paquete de Cloud Firestore

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
            SizedBox(height: 50), // Add space above the "Welcome to the App!" text
            const Text("Welcome to the App!",
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.w500)),
            const SizedBox(height: 50),
            ElevatedButton(
              child: Text('Select Birth Date'),
              onPressed: () async {
                final DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );
                if (pickedDate != null) {
                  // Save birth date to Firebase
                  saveBirthDateToFirebase(pickedDate);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void saveBirthDateToFirebase(DateTime birthDate) async {
    try {
      // Access the current user from Firebase Authentication
      User? user = FirebaseAuth.instance.currentUser;

      // Reference to the users collection in Firestore
      CollectionReference users = FirebaseFirestore.instance.collection('users');

      // Update the birth date for the current user
      await users.doc(user!.uid).update({
        'birthDate': birthDate,
      });

      // Navigate to the next screen or perform any other actions upon successful save
      print('Birth Date saved successfully: $birthDate');
    } catch (e) {
      print('Error saving birth date: $e');
      // Handle any errors that occur during the save process
    }
  }
}
