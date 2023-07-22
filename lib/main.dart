import 'package:bitattendance/screens/homeScreen.dart';
import 'package:bitattendance/screens/splashScreen.dart';
import 'package:bitattendance/services/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => AuthProvider())],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
                seedColor: Color.fromARGB(255, 209, 108, 227)),
            useMaterial3: true,
            fontFamily: 'Montserrat'),
        debugShowCheckedModeBanner: false,
        home: splashScreen(),
      ),
    );
  }
}
