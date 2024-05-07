import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'Home.dart';

void main(){
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey='your key';

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Home()
    );
  }
}

