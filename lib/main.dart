import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tailor_app/firebase_options.dart';
import 'package:tailor_app/screens/authscreen/splash_screen.dart';
import 'package:tailor_app/state/authstate.dart';
import 'package:tailor_app/state/customer_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Authstate>(create: (_) => Authstate()),
        ChangeNotifierProvider<CustomerState>(create: (_) => CustomerState()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Tailor App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: SplashScreen(),
      ),
    );
  }
}
