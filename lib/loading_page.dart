import 'dart:developer';

import 'package:facebook/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'LoginPage/LoginPage.dart';
import 'MainPage/MainPage.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            log('Error !');
          }

          if (snapshot.connectionState == ConnectionState.done) {
            return StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.data == null) {
                  // ignore: prefer_const_constructors
                  return LoginPage();
                } else {
                  // ignore: prefer_const_constructors
                  return MainPage();
                }
              },
            );
          }

          return const Center(
            child: CupertinoActivityIndicator(),
          );
        },
      ),
    );
  }
}
