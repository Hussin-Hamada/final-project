import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/User/control.dart';
import 'package:flutter_application_1/User/sensor_data.dart';
import 'package:flutter_application_1/home.dart';
import 'package:flutter_application_1/login.dart';

class HomeUser extends StatefulWidget {
  const HomeUser({super.key});

  @override
  State<HomeUser> createState() => _HomeUserState();
}

class _HomeUserState extends State<HomeUser>
    with SingleTickerProviderStateMixin {
  late TabController _controler;
  @override
  void initState() {
    super.initState();
    _controler = TabController(length: 3, vsync: this, initialIndex: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Smart agriculture"),
        actions: [
          IconButton(
            onPressed: () {
              logout(context);
            },
            icon: const Icon(
              Icons.logout,
            ),
          ),
          //IconButton(onPressed: () {}, icon: Icon(Icons.search)),
          PopupMenuButton<String>(
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem(
                  child: Text("main"),
                  value: "settings",
                ),
                const PopupMenuItem(
                  child: Text("chat"),
                  value: "settings",
                ),
                const PopupMenuItem(
                  child: Text("Logout"),
                  value: "logout",
                ),
                const PopupMenuItem(
                  child: Text("Settings"),
                  value: "settings",
                ),
              ];
            },
          ),
        ],
        bottom: TabBar(
          controller: _controler,
          tabs: const [
            Tab(
              text: "home page",
            ),
            Tab(
              text: "Sensors data",
            ),
            Tab(
              text: "Controll",
            )
          ],
        ),
      ),
      body: TabBarView(
        controller: _controler,
        children: const [
          Home(),
          SensorData(),
          Control(),
        ],
      ),
    );
  }

  logout(BuildContext context) {
    const CircularProgressIndicator();
    FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }
}
