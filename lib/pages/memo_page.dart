import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_flutter/model/memo.dart';
import 'package:flutter/material.dart';

class MemoPage extends StatelessWidget {
  final QueryDocumentSnapshot memo;
  MemoPage(this.memo);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(memo['title']),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('メモ内容', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(memo['detail'], style: TextStyle(fontSize: 10),)
          ],
        ),
      ),
    );
  }
}
