import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const AgeTimerApp());
}

class AgeTimerApp extends StatelessWidget {
  const AgeTimerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Age Timer Motivation',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AgeTimerPage(),
    );
  }
}

class AgeTimerPage extends StatefulWidget {
  const AgeTimerPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AgeTimerPageState createState() => _AgeTimerPageState();
}

class _AgeTimerPageState extends State<AgeTimerPage> {
  final DateTime _birthDate =
      DateTime(2002, 1, 1); // Coloca tu fecha de nacimiento aquí
  late DateTime _currentTime;

  @override
  void initState() {
    super.initState();
    _currentTime = DateTime.now();
    _startTimer();
  }

  void _startTimer() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          _currentTime = DateTime.now();
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    int age = _calculateAge(_currentTime);
    int hours = _calculatehours(_currentTime);
    int minutes = _calculateMinutes(_currentTime);
    int seconds = _calculateSeconds(_currentTime);
    int days = _calculateDays(_currentTime);

    return Scaffold(
      body: Center(
        child: Text(
          '${formatValue(age)}.${formatValue(days)}${formatValue(hours)}${formatValue(minutes)}${formatValue(seconds)}',
          style: const TextStyle(
              fontSize: 50, color: Color.fromARGB(255, 49, 49, 49)),
        ),
      ),
    );
  }

  int _calculateAge(DateTime currentTime) {
    int age = currentTime.year - _birthDate.year;
    if (currentTime.month < _birthDate.month ||
        (currentTime.month == _birthDate.month &&
            currentTime.day < _birthDate.day)) {
      age--;
    }
    return age;
  }

  int _calculatehours(DateTime currentTime) {
    int hours = currentTime.hour - _birthDate.hour;
    if (currentTime.minute < _birthDate.minute ||
        (currentTime.minute == _birthDate.minute &&
            currentTime.second < _birthDate.second)) {
      hours--;
    }
    return hours;
  }

  int _calculateMinutes(DateTime currentTime) {
    int minutes = currentTime.minute - _birthDate.minute;
    if (currentTime.second < _birthDate.second) {
      minutes--;
    }
    return minutes;
  }

  int _calculateSeconds(DateTime currentTime) {
    int seconds = currentTime.second - _birthDate.second;
    return seconds < 0 ? 60 + seconds : seconds;
  }

  int _calculateDays(DateTime currentTime) {
    int days = currentTime.day - _birthDate.day;
    if (currentTime.hour < _birthDate.hour ||
        (currentTime.hour == _birthDate.hour &&
            currentTime.minute < _birthDate.minute)) {
      days--;
    }
    return days;
  }

  String formatValue(int value) {
    return value < 10 ? '0$value' : value.toString();
  }
}

void saveBirthDateToFirebase(DateTime birthDate) async {
  try {
    // Accede al usuario actual desde Firebase Authentication
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Referencia a la colección 'users' en Firestore
      CollectionReference users = FirebaseFirestore.instance.collection('users');

      // Verifica si el documento del usuario existe
      var userDoc = await users.doc(user.uid).get();
      if (userDoc.exists) {
        // El documento existe, actualiza la fecha de nacimiento
        await users.doc(user.uid).update({
          'birthDate': birthDate,
        });
        print('Fecha de nacimiento actualizada exitosamente: $birthDate');
      } else {
        // El documento no existe, créalo con la fecha de nacimiento
        await users.doc(user.uid).set({
          'birthDate': birthDate,
          // Puedes agregar otros campos de inicialización aquí si es necesario
        });
        print('Documento de usuario creado con fecha de nacimiento: $birthDate');
      }
    } else {
      print('El usuario no está autenticado');
      // Maneja el caso donde el usuario no está autenticado, si es necesario
    }
  } catch (e) {
    print('Error al guardar la fecha de nacimiento: $e');
    // Maneja cualquier error que ocurra durante el proceso de guardado
  }
}
