import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

Widget shareLink(BuildContext context) {
  return Scaffold(
    body: FutureBuilder(
      future: Future.delayed(const Duration(milliseconds: 20), () {
        return Share.share(
            'https://play.google.com/store/apps/details?id=com.shefeek1999.music_app');
      }),
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.data;
      },
    ),
  );
}
