import 'package:flutter/material.dart';
import 'package:pos_project/constants/custom_color.dart';
import 'package:pos_project/screens/auth/login.dart';
import 'package:pos_project/screens/configuration.dart';
import 'package:pos_project/screens/edit_profile.dart';
import 'package:pos_project/screens/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer(
      {super.key,
      required this.name,
      required this.username,
      required this.active});

  final String name, username, active;

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  logout(context) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    localStorage.remove('userData');
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const Login()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: CustomColor().primary),
            accountName: Text(
              widget.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            accountEmail: Text(
              "user: ${widget.username}",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            currentAccountPicture: const FlutterLogo(),
          ),
          ListTile(
            tileColor: widget.active == 'Home' ? CustomColor().primary : null,
            textColor: widget.active == 'Home' ? Colors.white : null,
            iconColor: widget.active == 'Home' ? Colors.white : null,
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const Home(),
                ),
                (route) => false,
              );
            },
          ),
          ListTile(
            tileColor:
                widget.active == 'Edit Profile' ? CustomColor().primary : null,
            textColor: widget.active == 'Edit Profile' ? Colors.white : null,
            iconColor: widget.active == 'Edit Profile' ? Colors.white : null,
            leading: const Icon(Icons.person),
            title: const Text('Edit Profile'),
            onTap: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const EditProfile(),
                ),
                (route) => false,
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.build),
            title: const Text('Configuration'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Configuration(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.do_disturb),
            title: const Text('Logout'),
            onTap: () {
              logout(context);
            },
          ),
        ],
      ),
    );
  }
}
