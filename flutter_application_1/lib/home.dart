import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/user_model.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/pattern.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: ListView(
            children: <Widget>[
              ListTile(
                leading: const CircleAvatar(
                  radius: 50,
                ),
                title: Text("${loggedInUser.name}"),
                subtitle: Text('${loggedInUser.clas} in smart agriculture'),
              ),
              const SizedBox(height: 45),
              ListTile(
                leading: const Icon(Icons.email),
                title: const Text('Email'),
                subtitle: Text('${loggedInUser.email}'),
              ),
              const SizedBox(height: 45),
              ListTile(
                leading: const Icon(Icons.phone),
                title: const Text('Phone number'),
                subtitle: Text('${loggedInUser.phone}'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
