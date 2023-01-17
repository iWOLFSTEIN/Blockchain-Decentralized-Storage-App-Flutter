import 'package:blockchain_decentralized_storage_system/provider/data_provider.dart';
import 'package:blockchain_decentralized_storage_system/provider/database_provider.dart';
import 'package:blockchain_decentralized_storage_system/provider/network_data.dart';
import 'package:blockchain_decentralized_storage_system/screens/home.dart';
import 'package:blockchain_decentralized_storage_system/screens/intro.dart';
import 'package:blockchain_decentralized_storage_system/services/database_helper.dart';
import 'package:blockchain_decentralized_storage_system/services/login_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:grpc/grpc.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
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
    return MultiProvider(
      providers: [
        // ChangeNotifierProvider(create: (context) => DataProvider()),

        ChangeNotifierProvider(create: (context) => DatabaseHelper()),
        ChangeNotifierProvider(create: (context) => NetworkData()),

        ChangeNotifierProxyProvider<NetworkData, DataProvider>(
            create: (context) => DataProvider(NetworkData(), 0.0),
            update: (context, networkData, dataProvider) =>
                DataProvider(networkData, dataProvider!.balance)),

        ChangeNotifierProxyProvider<DatabaseHelper, DatabaseProvider>(
            create: (context) => DatabaseProvider([], DatabaseHelper.instance),
            update: (context, database, databaseProvider) =>
                DatabaseProvider(databaseProvider!.items, database)),
      ],
      child: StartApp(),
    );
  }
}

class StartApp extends StatefulWidget {
  const StartApp({super.key});

  @override
  State<StartApp> createState() => _StartAppState();
}

class _StartAppState extends State<StartApp> {
  bool isLoggedIn = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserLoginState();
  }

  getUserLoginState() async {
    bool loginState = await LoginState.getLoginState();
    setState(() {
      isLoggedIn = loginState;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hyperspace',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: isLoggedIn ? Home() : Intro(),
    );
  }
}
