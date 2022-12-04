import 'package:blockchain_decentralized_storage_system/Screens/home.dart';
import 'package:flutter/material.dart';

class Intro extends StatelessWidget {
  const Intro({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Expanded(
              child: Container(
            color: Color(0xFF4859A0),
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ImageIcon(
                  AssetImage('images/cube.png'),
                  color: Colors.white,
                  size: 80,
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'HYPER',
                      style: TextStyle(color: Colors.black, fontSize: 22.5),
                    ),
                    Text(
                      'SPACE',
                      style: TextStyle(color: Colors.white, fontSize: 22.5),
                    )
                  ],
                ),
              ],
            ),
          )),
          Container(
            height: 200,
            width: double.infinity,
            color: Colors.white,
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextField(
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.key),
                      hintText: 'Enter private key',
                      suffix: Text(
                        'Generate',
                        style: TextStyle(color: Colors.blue),
                      )),
                ),
                Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Color(0xFF4859A0),
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => Home()),
                          (route) => false);
                    },
                    child: Text(
                      'Continue',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      )),
    );
  }
}
