import 'package:blockchain_decentralized_storage_system/Screens/home.dart';
import 'package:blockchain_decentralized_storage_system/Screens/intro.dart';
import 'package:blockchain_decentralized_storage_system/src/generated/connection.pbgrpc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:grpc/grpc.dart';
import 'Services/client.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // var response;
  // try {
  //   response = await getRPCResponse();
  //   print(response);
  // } catch (e) {
  //   print("error getting response");
  //   print(e.toString());
  // }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Intro(),
    );
  }
}
