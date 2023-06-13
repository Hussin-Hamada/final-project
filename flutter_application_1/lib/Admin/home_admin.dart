import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Admin/add_user.dart';
import 'package:flutter_application_1/Admin/report.dart';
import 'package:flutter_application_1/home.dart';
import 'package:flutter_application_1/login.dart';

class HomeAdmin extends StatefulWidget {
  const HomeAdmin({super.key});

  @override
  State<HomeAdmin> createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin>
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
              text: "Add user",
            ),
            Tab(
              text: "Report",
            )
          ],
        ),
      ),
      body: TabBarView(
        controller: _controler,
        children: const [
          Home(),
          AddUserScreen(),
          Report(),
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
