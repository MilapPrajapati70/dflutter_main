import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'Post.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  FirebaseDatabase database = FirebaseDatabase.instance;

  List<Post> posts = [];
  final GlobalKey<AnimatedListState> _key = GlobalKey();
  FirebaseAuth auth = FirebaseAuth.instance;

  Future getData() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref();

    final snapshot = await ref.child('posts/').get();
    if (snapshot.exists) {
      String data = jsonEncode(snapshot.value);
      List<Object?> tempList = (jsonDecode(data)).entries.map((entry) => entry.value).toList();
      posts.clear();
      _key.currentState?.removeAllItems((context, animation) => Container());
      DatabaseReference myRef = FirebaseDatabase.instance.ref().child('candidate').child(auth.currentUser?.uid ?? "na");
      final snapshot2 = await myRef.get();
      if (snapshot2.exists) {
        List tempConnectionList = (jsonDecode(jsonEncode(snapshot2.value ?? {})))["connectionList"] ?? [];
        for (var value in tempList) {
          if (tempConnectionList.contains((jsonDecode(jsonEncode(value ?? {})))["uid"].toString())) {
            posts.add(
              Post(
                name: (jsonDecode(jsonEncode(value ?? {})))["name"].toString(),
                uid: (jsonDecode(jsonEncode(value ?? {})))["uid"].toString(),
                title: (jsonDecode(jsonEncode(value ?? {})))["title"].toString(),
                content: (jsonDecode(jsonEncode(value ?? {})))["content"].toString(),
                imageUrl: (jsonDecode(jsonEncode(value ?? {})))["imageUrl"].toString(),
              ),
            );
            _key.currentState?.insertItem(0, duration: const Duration(seconds: 1));
            setState(() {});
          }
        }
      }
    } else {}
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: getData,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                  child: AnimatedList(
                key: _key,
                initialItemCount: 0,
                itemBuilder: (context, index, animation) => SizeTransition(
                  key: UniqueKey(),
                  sizeFactor: animation,
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: Card(
                          child: Container(
                            margin: const EdgeInsets.all(10),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  posts[index].name ?? "",
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                                ),
                                AspectRatio(
                                  aspectRatio: 2,
                                  child: Image.asset(
                                    posts[index].imageUrl ?? "",
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  posts[index].title ?? "",
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                                ),
                                Text(
                                  posts[index].content ?? "",
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
