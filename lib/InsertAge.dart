import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Importa el paquete de Firebase Authentication
import 'package:cloud_firestore/cloud_firestore.dart'; // Importa el paquete de Cloud Firestore
import 'package:auth_firebase/AgeTimer.dart'; // Importa el paquete de AgeTimer

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
            const SizedBox(height: 30),
            ElevatedButton(
            child: Text('Continue to Age Timer'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AgeTimerApp()),
              );
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

    if (user != null) {
      // Reference to the users collection in Firestore
      CollectionReference users = FirebaseFirestore.instance.collection('users');

      // Check if the user document exists
      var userDoc = await users.doc(user.uid).get();
      if (userDoc.exists) {
        // Document exists, update the birth date
        await users.doc(user.uid).update({
          'birthDate': birthDate,
        });
        print('Birth Date updated successfully: $birthDate');
      } else {
        // Document does not exist, create it with the birth date
        await users.doc(user.uid).set({
          'birthDate': birthDate,
          // You can add other fields to initialize here if needed
        });
        print('User document created with Birth Date: $birthDate');
      }
    } else {
      print('User is not authenticated');
      // Handle case where user is not authenticated, if needed
    }
  } catch (e) {
    print('Error saving birth date: $e');
    // Handle any errors that occur during the save process
  }
}

}
