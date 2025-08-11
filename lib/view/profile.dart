import 'package:flutter/material.dart';
import 'package:legal_assistance_mobile/componant/myButton.dart';
import 'package:legal_assistance_mobile/componant/profileList.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          margin: EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                CircleAvatar(
                  minRadius: 80,
                  child: Icon(Icons.person, size: 80),
                ),
                Column(
                  children: [
                    Profilelist(
                      title: "Name",
                      text: "Ahmed",
                      icon: Icon(Icons.person),
                    ),
                    Profilelist(
                      title: "Age",
                      text: "18",
                      icon: Icon(Icons.numbers),
                    ),
                    Profilelist(
                      title: "Address",
                      text: "1316496868",
                      icon: Icon(Icons.location_on),
                    ),
                    Profilelist(
                      title: "Email",
                      text: "user@gmail.com",
                      icon: Icon(Icons.person),
                    ),
                    Profilelist(
                      title: "Address",
                      text: "1316496868",
                      icon: Icon(Icons.location_on),
                    ),
                    Profilelist(
                      title: "Email",
                      text: "user@gmail.com",
                      icon: Icon(Icons.person),
                    ),
                    Profilelist(
                      title: "Address",
                      text: "1316496868",
                      icon: Icon(Icons.location_on),
                    ),
                    Profilelist(
                      title: "Email",
                      text: "user@gmail.com",
                      icon: Icon(Icons.person),
                    ),
                  ],
                ),
                MyButton(text: "Edit"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
