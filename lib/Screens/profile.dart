import 'dart:io';

import 'package:blockchain_decentralized_storage_system/provider/database_provider.dart';
import 'package:blockchain_decentralized_storage_system/services/database_helper.dart';
import 'package:blockchain_decentralized_storage_system/utils/constants.dart';
import 'package:blockchain_decentralized_storage_system/widgets/app_branding.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';
import 'package:web_socket_channel/io.dart';
import 'package:path/path.dart';
import '../utils/app_directory.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  double accountBalance = 0;
  late Client httpClient = Client();
  late Web3Client ethClient =
      Web3Client(HTTP_URL, httpClient, socketConnector: () {
    return IOWebSocketChannel.connect(WS_URL).cast<String>();
  });
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getAccountBalance();
  }

  getAccountBalance() async {
    var databaseProvider =
        Provider.of<DatabaseProvider>(this.context, listen: false);

    print(databaseProvider.items);
    print(databaseProvider.items[0]['privateKey']);
    print(databaseProvider.items[0]['privateKey'].length);
    var credentials = await ethClient
        .credentialsFromPrivateKey(databaseProvider.items[0]['privateKey']);
    EtherAmount balance = await ethClient.getBalance(credentials.address);
    setState(() {
      accountBalance = balance.getValueInUnit(EtherUnit.ether);
    });
  }

  @override
  Widget build(BuildContext context) {
    var databaseProvider = Provider.of<DatabaseProvider>(context);
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
                    '$accountBalance ',
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
              icon: Icons.repeat_sharp,
              title: 'Change Account',
              trailing: Icon(Icons.arrow_forward),
              action: () {},
            ),
            SizedBox(
              height: 10,
            ),
            infoTile(
              icon: Icons.save_alt,
              title: 'Save Private Key',
              trailing: Icon(Icons.arrow_forward),
              action: () async {
                try {
                  var newPath = await getAppDirectory() +
                      "/${databaseProvider.items[0]['name']}.db";
                  Directory documentsDirectory =
                      await getApplicationDocumentsDirectory();
                  String path = join(documentsDirectory.path, "database.db");
                  File databaseFile = File(path);
                  await databaseFile.copy(newPath);
                } catch (e) {
                  print(e.toString());
                }
              },
            ),
            SizedBox(
              height: 10,
            ),
            infoTile(
              icon: Icons.privacy_tip_outlined,
              title: 'Privacy Policy',
              trailing: Icon(Icons.read_more),
              action: () {},
            ),
            SizedBox(
              height: 10,
            ),
            infoTile(
              icon: Icons.person_outline,
              title: 'Logout',
              trailing: Icon(Icons.logout),
              action: () {},
            ),
          ],
        ),
      )),
    );
  }

  Container infoTile(
      {required icon, required title, required trailing, required action}) {
    return Container(
      height: 65,
      decoration: BoxDecoration(
          color:
              //Colors.orange,
              Color(0xFFFAFAFA),
          borderRadius: BorderRadius.all(Radius.circular(15))),
      child: GestureDetector(
        onTap: action,
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
          radius: 26,
          backgroundImage: NetworkImage(
              'https://www.cnet.com/a/img/resize/e547a2e4388fcc5ab560f821ac170a59b9fb0143/hub/2021/12/13/d319cda7-1ddd-4855-ac55-9dcd9ce0f6eb/unnamed.png?auto=webp&fit=crop&height=1200&width=1200'),
        ),
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
