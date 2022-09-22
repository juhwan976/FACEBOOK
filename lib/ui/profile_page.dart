// ignore_for_file: file_names

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:scrolls_to_top/scrolls_to_top.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({
    Key? key,
    required this.scrollController,
    required this.isOnScreen,
  }) : super(key: key);

  final bool isOnScreen;

  final ScrollController scrollController;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return ScrollsToTop(
      onScrollsToTop: (event) async {
        if(!widget.isOnScreen) {
          return;
    }
        if(widget.scrollController.hasClients) {
          widget.scrollController.animateTo(
            event.to,
            duration: event.duration,
            curve: event.curve,
          );
        }
      },
      child: Scaffold(
        body: ListView.builder(
          controller: widget.scrollController,
          itemCount: 200,
          itemBuilder: (context, index) {
            return Container(
              height: 20,
              child: Center(
                child: Text('$index'),
              ),
            );
          },
        ),
      ),
    );
  }
}
