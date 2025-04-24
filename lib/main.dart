import 'package:desbloqueio_app/pages/desbloqueio_app.dart';
import 'package:desbloqueio_app/widgets/auth_ckeck.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';

import 'services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    //abaixo, somente as configurações para web

      options: const FirebaseOptions(
          apiKey: "AIzaSyBaAy9eXeDlVXrqudMHXmK_SoSrIPmCq9c",
          authDomain: "desbloqueio-rep.firebaseapp.com",
          projectId: "desbloqueio-rep",
          storageBucket: "desbloqueio-rep.firebasestorage.app",
          messagingSenderId: "455413958937",
          appId: "1:455413958937:web:c7398d4b1eae50fbd01d88",
          measurementId: "G-DNSMQDJH7R"
      )

  );
  Get.put(AuthService());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Desbloqueio de REP',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        //colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: false,

      ),
      debugShowCheckedModeBanner: false,
      home: AuthCheck(),
    );
  }
}


