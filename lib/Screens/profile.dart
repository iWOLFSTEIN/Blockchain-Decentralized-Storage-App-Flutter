import 'dart:io';

import 'package:alert/alert.dart';
import 'package:blockchain_decentralized_storage_system/provider/database_provider.dart';
import 'package:blockchain_decentralized_storage_system/screens/intro.dart';
import 'package:blockchain_decentralized_storage_system/services/login_state.dart';
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
import '../widgets/custom_alert_dialogues.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    var databaseProvider = Provider.of<DatabaseProvider>(context);
    var dataProvider = Provider.of<DataProvider>(this.context);
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
                    '${dataProvider.balance} ',
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
              icon: Icons.key,
              title: 'Show Private Key',
              trailing: Icon(Icons.remove_red_eye_outlined),
              action: () {},
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
              action: () {},
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
                  });
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
    await LoginState.setLoginState(value: false);
    databaseProvider.deleteDatabase();
  }

  saveAccountAlert(context, databaseProvider,
      {primaryAction, secondaryAction}) {
    var alert = CustomModifiedAlertDialogue(
      title: 'Save Hyperspace Account',
      subtitle:
          'Save your account for later use. If you dont save your account all the data will be lost.',
      action: primaryAction,
      actionTitle: 'Save Account',
      secondaryAction: secondaryAction,
    );
    showDialog(context: context, builder: (context) => alert);
  }

  saveDatabase(databaseProvider) async {
    try {
      var newPath =
          await getAppDirectory() + "/${databaseProvider.items[0]['name']}.db";
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
    var name = databaseProvider.items[0]['name'];
    var time = databaseProvider.items[0]['time'].split('.')[0].split(' ')[0];

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
