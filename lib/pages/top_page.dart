import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_flutter/model/memo.dart';
import 'package:firebase_flutter/pages/memo_page.dart';
import 'package:flutter/material.dart';

import 'add_edit_memo_page.dart';

class TopPage extends StatefulWidget {
  TopPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _TopPageState createState() => _TopPageState();
}

class _TopPageState extends State<TopPage> {
  CollectionReference memos;

  Future<void> deleteMemo(String docId) async {
    var document = FirebaseFirestore.instance.collection('memo').doc(docId);
    document.delete();
  }

  @override
  void initState() {
    super.initState();
    memos = FirebaseFirestore.instance.collection('memo');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('firebase × flutter'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: memos.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          return ListView.builder(
            itemCount: snapshot.data.docs.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(snapshot.data.docs[index]['title']),
                trailing: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    showModalBottomSheet(context: context, builder: (context) {
                      return SafeArea(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              leading: Icon(Icons.edit, color: Colors.blueAccent),
                              title: Text('編集'),
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.push(context, MaterialPageRoute(builder: (context) => AddEditMemoPage(memo: snapshot.data.docs[index])));
                              },
                            ),
                            ListTile(
                              leading: Icon(Icons.delete, color: Colors.redAccent),
                              title: Text('削除'),
                              onTap: () async {
                              await deleteMemo(snapshot.data.docs[index].id);
                              Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      );}
                      );
                    },
                ),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => MemoPage(snapshot.data.docs[index])));
                },
              );
            },
          );
        }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddEditMemoPage()));
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
