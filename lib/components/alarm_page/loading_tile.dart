import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../models/global_model.dart';

class LoadingTile extends StatelessWidget {
  const LoadingTile({
    Key? key,
    required this.isEndStream,
  }) : super(key: key);

  final Stream<bool> isEndStream;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: StreamBuilder(
        stream: isEndStream,
        builder: (context, AsyncSnapshot<bool> snapshot) {
          if(snapshot.hasData) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: snapshot.data! ? 0 : appHeight * 0.12,
              color: Colors.white,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: snapshot.data! ? 0 : 1,
                child: const CupertinoActivityIndicator(),
              ),
            );
          }

          return const CupertinoActivityIndicator();
        }
      ),
    );
  }
}
