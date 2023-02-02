import 'package:blockchain_decentralized_storage_system/provider/data_provider.dart';
import 'package:blockchain_decentralized_storage_system/provider/database_provider.dart';
import 'package:blockchain_decentralized_storage_system/provider/network_data.dart';
import 'package:blockchain_decentralized_storage_system/screens/home.dart';
import 'package:blockchain_decentralized_storage_system/screens/intro.dart';
import 'package:blockchain_decentralized_storage_system/provider/database_helper.dart';
import 'package:blockchain_decentralized_storage_system/screens/upload.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:grpc/grpc.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => DatabaseHelper()),
        ChangeNotifierProvider(create: (context) => NetworkData()),
        ChangeNotifierProxyProvider<NetworkData, DataProvider>(
            create: (context) => DataProvider(
                  NetworkData(),
                  0.0,
                ),
            update: (context, networkData, dataProvider) => DataProvider(
                  networkData,
                  dataProvider!.balance,
                )),
        ChangeNotifierProxyProvider<DatabaseHelper, DatabaseProvider>(
            create: (context) =>
                DatabaseProvider([], [], DatabaseHelper.instance),
            update: (context, database, databaseProvider) => DatabaseProvider(
                databaseProvider!.accountTableItems,
                databaseProvider.filesTableItems,
                database)),
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
    List<Map<String, dynamic>> accountTableData =
        await DatabaseHelper.instance.queryAllChildrenRowsFromAccountTable();
    if (!listEquals(accountTableData, [])) {
      setState(() {
        isLoggedIn = true;
      });
    }
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hyperspace',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: isLoggedIn ? Home() : Intro(),
      // home: Upload(),
    );
  }
}
