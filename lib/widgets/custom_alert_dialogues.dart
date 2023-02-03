import 'dart:io';
import 'package:path/path.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../provider/database_provider.dart';
import '../screens/home.dart';

class CustomModifiedAlertDialogue extends StatelessWidget {
  const CustomModifiedAlertDialogue(
      {Key? key,
      this.title,
      this.subtitle,
      this.action,
      this.actionTitle,
      this.secondaryAction,
      this.secondaryActionTitle = 'Go Back'})
      : super(key: key);
  final String? title;
  final String? subtitle;
  final Function()? action;
  final String? actionTitle;
  final Function()? secondaryAction;
  final String? secondaryActionTitle;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFECF7FE).withOpacity(0.0),
      body: Column(
        children: [
          EmptySpace(context: context),
          alertBox(context),
          EmptySpace(context: context),
        ],
      ),
    );
  }

  Widget alertBox(context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Container(
          height: 325,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(25))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AlertTitleSubtitle(title: title, subtitle: subtitle),
              Container(),
              Container(),
              AlertButton(action: action, actionTitle: actionTitle),
              Container(),
              Container(),
              GestureDetector(
                onTap: secondaryAction,
                child: Text(
                  secondaryActionTitle!,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18.5,
                    color: Color(0xFF1F1F1F),
                  ),
                ),
              ),
              Container(),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomGeneralAlertDialogue extends StatelessWidget {
  const CustomGeneralAlertDialogue({
    Key? key,
    this.title,
    this.subtitle,
    this.action,
    this.actionTitle,
  }) : super(key: key);
  final String? title;
  final String? subtitle;
  final Function()? action;
  final String? actionTitle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFECF7FE).withOpacity(0.0),
      body: Column(
        children: [
          EmptySpace(context: context),
          alertBox(context),
          EmptySpace(context: context),
        ],
      ),
    );
  }

  Widget alertBox(context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Container(
          height: 275,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(25))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AlertTitleSubtitle(title: title, subtitle: subtitle),
              Container(),
              AlertButton(action: action, actionTitle: actionTitle),
              Container(),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomListAlertDialogue extends StatelessWidget {
  const CustomListAlertDialogue({
    Key? key,
    this.title,
    this.subtitle,
    // this.action,
    // this.actionTitle,
    this.files,
  }) : super(key: key);
  final String? title;
  final String? subtitle;
  // final Function()? action;
  // final String? actionTitle;
  final List? files;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFECF7FE).withOpacity(0.0),
      body: Column(
        children: [
          EmptySpace(context: context),
          alertBox(context),
          EmptySpace(context: context),
        ],
      ),
    );
  }

  Widget alertBox(context) {
    List<Widget> widgetList = [];
    var databaseProvider = Provider.of<DatabaseProvider>(context);

    for (var file in files!) {
      var dividedPath = file.path.split('/');
      var name = dividedPath[dividedPath.length - 1].split('.')[0];
      var widget = ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
        onTap: () async {
          Directory documentsDirectory =
              await getApplicationDocumentsDirectory();
          String path = join(documentsDirectory.path, "database.db");
          file.copy(path).then((value) async {
            databaseProvider.fetchAndSetData();
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => Home()),
                (route) => false);
          });
        },
        leading: CircleAvatar(
          radius: 20,
          backgroundImage: AssetImage('images/profile_nft.png'),
        ),
        title: Text(
          name,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          file.path,
          overflow: TextOverflow.ellipsis,
        ),
      );
      widgetList.add(widget);
    }
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Container(
          height: 500,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(25))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              accountTitleSubtitle(),
              SizedBox(
                height: 15,
              ),
              (listEquals(widgetList, []))
                  ? Expanded(
                      child: Container(
                        child: Center(
                          child: Text(
                            'No accounts found',
                            style:
                                TextStyle(color: Colors.black.withOpacity(0.4)),
                          ),
                        ),
                      ),
                    )
                  : Expanded(
                      child: SingleChildScrollView(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: widgetList,
                      )),
                    ),
              Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Cancel',
                          style: TextStyle(color: Colors.blue),
                        )),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  accountTitleSubtitle() {
    return Column(
      children: [
        Text(
          title!,
          textAlign: TextAlign.center,
          style: const TextStyle(
              fontSize: 18,
              color: Color(0xFF1F1F1F),
              fontWeight: FontWeight.w600,
              height: 1.1),
        ),
        const SizedBox(
          height: 12.5,
        ),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
              color: Color(0xFFEBEFF5),
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Text(
            subtitle!,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF1F1F1F),
            ),
          ),
        ),
      ],
    );
  }
}

class CustomInfoListDialogue extends StatelessWidget {
  const CustomInfoListDialogue({
    Key? key,
    this.title,
    this.subtitle,
  }) : super(key: key);
  final String? title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFECF7FE).withOpacity(0.0),
      body: Column(
        children: [
          EmptySpace(context: context),
          alertBox(context),
          EmptySpace(context: context),
        ],
      ),
    );
  }

  Widget element(title, text) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(color: Colors.grey),
        ),
        SizedBox(
          height: 5,
        ),
        SelectableText(
          text,
          style: TextStyle(fontSize: 14, color: Colors.black.withOpacity(0.8)),
        ),
      ],
    );
  }

  Widget alertBox(context) {
    var databaseProvider = Provider.of<DatabaseProvider>(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Container(
          height: 500,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(25))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              accountTitleSubtitle(),
              SizedBox(
                height: 15,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      element('Name',
                          databaseProvider.accountTableItems[0]['name']),
                      SizedBox(
                        height: 15,
                      ),
                      element('Account Address',
                          databaseProvider.accountTableItems[0]['address']),
                      SizedBox(
                        height: 15,
                      ),
                      element('Public Key',
                          databaseProvider.accountTableItems[0]['public_key']),
                      SizedBox(
                        height: 15,
                      ),
                      element('Private Key',
                          '0x${databaseProvider.accountTableItems[0]['private_key']}'),
                    ],
                  ),
                ),
              ),
              Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Cancel',
                          style: TextStyle(color: Colors.blue),
                        )),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  accountTitleSubtitle() {
    return Column(
      children: [
        Text(
          title!,
          textAlign: TextAlign.center,
          style: const TextStyle(
              fontSize: 18,
              color: Color(0xFF1F1F1F),
              fontWeight: FontWeight.w600,
              height: 1.1),
        ),
        const SizedBox(
          height: 12.5,
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
              color: Color(0xFFEBEFF5),
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Text(
            subtitle!,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF1F1F1F),
            ),
          ),
        ),
      ],
    );
  }
}

class AlertButton extends StatelessWidget {
  const AlertButton({
    Key? key,
    required this.action,
    required this.actionTitle,
  }) : super(key: key);

  final Function()? action;
  final String? actionTitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      width: double.infinity,
      decoration: BoxDecoration(
          color: Color(0xFF4859A0).withOpacity(0.6),
          //  Color(0xFF9ED5FA),
          borderRadius: BorderRadius.all(Radius.circular(15))),
      child: TextButton(
          onPressed: action,
          child: Text(
            actionTitle!,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 18.5,
              color: Colors.white,
              //  Color(0xFF1F1F1F),
            ),
          )),
    );
  }
}

class AlertTitleSubtitle extends StatelessWidget {
  const AlertTitleSubtitle({
    Key? key,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  final String? title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title!,
          textAlign: TextAlign.center,
          style: const TextStyle(
              fontSize: 18,
              color: Color(0xFF1F1F1F),
              fontWeight: FontWeight.w600,
              height: 1.1),
        ),
        const SizedBox(
          height: 12.5,
        ),
        Text(
          subtitle!,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 15,
            color: Color(0xFF1F1F1F),
          ),
        ),
      ],
    );
  }
}

class EmptySpace extends StatelessWidget {
  const EmptySpace({
    Key? key,
    required this.context,
  }) : super(key: key);

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
          color: Colors.white.withOpacity(0.0),
        ),
      ),
    );
  }
}
