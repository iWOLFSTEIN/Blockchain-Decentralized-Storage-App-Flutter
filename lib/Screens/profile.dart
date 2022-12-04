import 'package:blockchain_decentralized_storage_system/widgets/app_branding.dart';
import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
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
            userInformation(),
            SizedBox(
              height: 40,
            ),
            infoTile(
              icon: Icons.balance,
              title: 'Account Balance',
              trailing: Text(
                '0.0000',
                style: TextStyle(fontSize: 17),
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
              action: () {},
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

  Row userInformation() {
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
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Adam Warlock',
              style: TextStyle(fontSize: 20.5),
            ),
            SizedBox(
              height: 3,
            ),
            Text(
              'created at 12/12/2022',
              style: TextStyle(
                  fontSize: 15.5, color: Color(0xFF6A6A6A).withOpacity(0.6)),
            ),
          ],
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
