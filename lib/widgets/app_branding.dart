import 'package:flutter/material.dart';

import '../Screens/profile.dart';

class AppBranding extends StatelessWidget {
  const AppBranding({
    Key? key,
    required this.profileIconVisibility,
  }) : super(key: key);

  final double profileIconVisibility;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          'images/cube.png',
          height: 35,
          width: 35,
        ),
        SizedBox(
          width: 7.5,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              children: [
                Text(
                  'HYPER',
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
                Text(
                  'SPACE',
                  style: TextStyle(color: Color(0xFF7D7D7D), fontSize: 20),
                )
              ],
            ),
            Text(
              'Mobile Client',
              style: TextStyle(color: Colors.blue, fontSize: 11),
            )
          ],
        ),
        Expanded(child: Container()),
        Opacity(
          opacity: profileIconVisibility,
          child: GestureDetector(
            onTap: (profileIconVisibility == 0.0)
                ? () {}
                : () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Profile()));
                  },
            child: Icon(
              Icons.person,
              color: Color(0xFF6A6A6A),
              size: 27.5,
            ),
          ),
        )
      ],
    );
  }
}
