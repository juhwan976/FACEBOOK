// ignore_for_file: file_names
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:facebook/loading_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            MaterialButton(
              child: const Text('로그아웃'),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();

                // ignore: use_build_context_synchronously
                Navigator.of(context).pushReplacement(
                  PageRouteBuilder(
                    // ignore: prefer_const_constructors
                    pageBuilder: (context, _, __) => LoadingPage(),
                    transitionDuration: const Duration(seconds: 0),
                  ),
                );
              },
            ),
            MaterialButton(
              child: const Text('정보 불러오기'),
              onPressed: () async {
                await FirebaseFirestore.instance
                    .collection('user')
                    .doc(FirebaseAuth.instance.currentUser!.uid.toString())
                    .get()
                    .then(
                  (snapshot) {
                    log(snapshot.data().toString());
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
