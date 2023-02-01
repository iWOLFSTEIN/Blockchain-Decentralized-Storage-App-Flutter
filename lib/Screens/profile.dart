import 'dart:io';

import 'package:alert/alert.dart';
import 'package:blockchain_decentralized_storage_system/provider/database_provider.dart';
import 'package:blockchain_decentralized_storage_system/screens/intro.dart';
import 'package:blockchain_decentralized_storage_system/utils/alerts.dart';
import 'package:blockchain_decentralized_storage_system/utils/constants.dart';
import 'package:blockchain_decentralized_storage_system/widgets/app_branding.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';
import 'package:web_socket_channel/io.dart';
import 'package:path/path.dart';
import '../provider/data_provider.dart';
import '../utils/app_directory.dart';
import '../utils/update_account_balance.dart';
import '../widgets/custom_alert_dialogues.dart';
import 'package:http/http.dart' as http;

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late http.Client httpClient = http.Client();
  late Web3Client ethClient =
      Web3Client(HTTP_URL, httpClient, socketConnector: () {
    return IOWebSocketChannel.connect(HTTP_URL).cast<String>();
  });
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    updateAccountBalance(this.context, ethClient);
  }

  @override
  Widget build(BuildContext context) {
    var databaseProvider = Provider.of<DatabaseProvider>(context);
    var dataProvider = Provider.of<DataProvider>(this.context);
    print(
        'Account Address: ${databaseProvider.accountTableItems[0]['address']}');
    print(
        'Private Key: ${databaseProvider.accountTableItems[0]['private_key']}');
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(
              height: 25,
            ),
            AppBranding(profileIconVisibility: 0.0),
            SizedBox(
              height: 30,
            ),
            userInformation(context, databaseProvider),
            SizedBox(
              height: 40,
            ),
            infoTile(
              icon: Icons.balance,
              title: 'Account Balance',
              trailing: Row(
                children: [
                  Text(
                    '${dataProvider.balance.toStringAsFixed(5)} ',
                    style: TextStyle(fontSize: 17),
                  ),
                  ImageIcon(
                    AssetImage('images/ether.png'),
                    size: 20,
                  )
                ],
              ),
              action: () {},
            ),
            SizedBox(
              height: 10,
            ),
            infoTile(
              icon: Icons.info_outline,
              title: 'Account Info',
              trailing: Icon(Icons.arrow_forward),
              action: () {
                var alert = CustomInfoListDialogue(
                  title: 'Account Info',
                  subtitle:
                      'All your files info is stored in your account file. Save your account often to avoid lost.',
                );
                showDialog(context: context, builder: (context) => alert);
              },
            ),
            SizedBox(
              height: 10,
            ),
            infoTile(
              icon: Icons.save_alt,
              title: 'Save Account',
              trailing: Icon(Icons.arrow_forward),
              action: () {
                saveAccountAlert(context, databaseProvider,
                    primaryAction: () async {
                  await saveDatabase(databaseProvider).then((value) {
                    Alert(message: 'Account saved').show();
                  });
                  Navigator.pop(context);
                }, secondaryAction: () {
                  Navigator.pop(context);
                });
              },
            ),
            SizedBox(
              height: 10,
            ),
            infoTile(
              icon: Icons.privacy_tip_outlined,
              title: 'Privacy Policy',
              trailing: Icon(Icons.arrow_forward),
              action: () {
                showInfoAlert(context);
              },
            ),
            SizedBox(
              height: 10,
            ),
            infoTile(
              icon: Icons.person_outline,
              title: 'Logout',
              trailing: Icon(Icons.logout),
              action: () async {
                try {
                  await saveAccountAlert(context, databaseProvider,
                      primaryAction: () async {
                    await saveDatabase(databaseProvider).then((value) {
                      Alert(message: 'Account saved').show();
                    });
                    await deleteDatabaseAndLogout(context, databaseProvider);
                  }, secondaryAction: () async {
                    await deleteDatabaseAndLogout(context, databaseProvider);
                  }, secondaryActionTitle: 'Not Now');
                } catch (e) {
                  print(e.toString());
                }
              },
            ),
          ],
        ),
      )),
    );
  }

  deleteDatabaseAndLogout(context, databaseProvider) async {
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) => Intro()), (route) => false);
    databaseProvider.deleteAccountTableData();
    databaseProvider.deleteFilesTableData();
  }

  saveAccountAlert(context, databaseProvider,
      {primaryAction, secondaryAction, secondaryActionTitle = 'Go Back'}) {
    var alert = CustomModifiedAlertDialogue(
      title: 'Save Hyperspace Account',
      subtitle:
          'Save your account for later use. If you dont save your account all the data will be lost.',
      action: primaryAction,
      actionTitle: 'Save Account',
      secondaryAction: secondaryAction,
      secondaryActionTitle: secondaryActionTitle,
    );
    showDialog(context: context, builder: (context) => alert);
  }

  saveDatabase(databaseProvider) async {
    try {
      var newPath = await getAppDirectory() +
          "/${databaseProvider.accountTableItems[0]['name']}.db";
      Directory documentsDirectory = await getApplicationDocumentsDirectory();
      String path = join(documentsDirectory.path, "database.db");
      File databaseFile = File(path);
      await databaseFile.copy(newPath);
    } catch (e) {
      print(e.toString());
    }
  }

  Widget infoTile(
      {required icon, required title, required trailing, required action}) {
    return GestureDetector(
      onTap: action,
      child: Container(
        height: 65,
        decoration: BoxDecoration(
            color:
                //Colors.orange,
                Color(0xFFFAFAFA),
            borderRadius: BorderRadius.all(Radius.circular(15))),
        child: Row(
          children: [
            SizedBox(
              width: 15,
            ),
            Icon(
              icon,
              size: 22,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              title,
              style: TextStyle(fontSize: 17),
            ),
            Expanded(child: SizedBox()),
            trailing,
            SizedBox(
              width: 15,
            ),
          ],
        ),
      ),
    );
  }

  Row userInformation(context, databaseProvider) {
    var name = databaseProvider.accountTableItems[0]['name'];
    int secondsSinceEpoch = databaseProvider.accountTableItems[0]['created_at'];
    var time = DateTime.fromMillisecondsSinceEpoch(secondsSinceEpoch * 1000)
        .toString()
        .split(' ')[0];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
            radius: 26, backgroundImage: AssetImage('images/profile_nft.png')),
        SizedBox(
          width: 10,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(fontSize: 20.5),
              ),
              SizedBox(
                height: 3,
              ),
              Text(
                "created on $time",
                style: TextStyle(
                    fontSize: 15.5, color: Color(0xFF6A6A6A).withOpacity(0.6)),
              ),
            ],
          ),
        ),
        Expanded(child: SizedBox()),
        Icon(
          Icons.edit,
          color: Color(0xFF6A6A6A),
        ),
      ],
    );
  }
}
