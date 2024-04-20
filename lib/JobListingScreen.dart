import 'package:dflutter_main/AddJobScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'Job.dart';
import 'JobDetailScreen.dart';

class JobListingScreen extends StatefulWidget {
  const JobListingScreen({super.key});

  @override
  State<JobListingScreen> createState() => _JobListingScreenState();
}

class _JobListingScreenState extends State<JobListingScreen> {
  List<Job> jobs = [];
  final GlobalKey<AnimatedListState> _key = GlobalKey();
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.child('jobs/').get();
    if (snapshot.exists) {
      String data = jsonEncode(snapshot.value);
      List<Object?> tempList = (jsonDecode(data)).entries.map((entry) {
        var tempEntry = entry.value;
        tempEntry["key"] = entry.key;
        return tempEntry;
      }).toList();
      jobs.clear();
      _key.currentState?.removeAllItems((context, animation) => Container());
      for (var value in tempList) {
        jobs.add(Job(
          key: (jsonDecode(jsonEncode(value ?? {})))["key"].toString(),
          company: (jsonDecode(jsonEncode(value ?? {})))["company"].toString(),
          deadline: (jsonDecode(jsonEncode(value ?? {})))["deadline"].toString(),
          jobdec: (jsonDecode(jsonEncode(value ?? {})))["jobdec"].toString(),
          jobtitle: (jsonDecode(jsonEncode(value ?? {})))["jobtitle"].toString(),
          location: (jsonDecode(jsonEncode(value ?? {})))["location"].toString(),
          mail: (jsonDecode(jsonEncode(value ?? {})))["mail"].toString(),
          salary: (jsonDecode(jsonEncode(value ?? {})))["salary"].toString(),
          skills: (jsonDecode(jsonEncode(value ?? {})))["skills"].toString(),
          uid: (jsonDecode(jsonEncode(value ?? {})))["uid"].toString(),
          image: (jsonDecode(jsonEncode(value ?? {})))["image"].toString(),
          connectionList: (jsonDecode(jsonEncode(value ?? {})))["connectionList"] ?? [],
        ));
        _key.currentState?.insertItem(0, duration: const Duration(seconds: 1));
      }
    } else {
      print('No data available.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Jobs"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddJobScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: RefreshIndicator(
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
                  itemBuilder: (context, index, animation) {
                    return SizeTransition(
                      key: UniqueKey(),
                      sizeFactor: animation,
                      child: Column(
                        children: [
                          Card(
                            child: Container(
                              margin: const EdgeInsets.all(10),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => JobDetailScreen(
                                                  jobDetail: jobs[index],
                                                )),
                                      );
                                    },
                                    child: Column(
                                      children: [
                                        AspectRatio(
                                          aspectRatio: 3,
                                          child: Image.asset(
                                            jobs[index].image,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              jobs[index].jobtitle,
                                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              jobs[index].jobdec ?? "",
                                              style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 15),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () async {
                                            if (jobs[index].connectionList.contains(auth.currentUser?.uid ?? "na")) {
                                              return;
                                            }

                                            jobs[index].connectionList.add(auth.currentUser?.uid ?? "na");
                                            DatabaseReference userRef = FirebaseDatabase.instance.ref().child('jobs').child(jobs[index].key);
                                            await userRef.update({
                                              "connectionList": jobs[index].connectionList.toSet().toList(),
                                            });

                                            setState(() {});
                                          },
                                          child: Card(
                                            color: jobs[index].connectionList.contains(auth.currentUser?.uid ?? "na") ? Colors.green : Colors.blue,
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(10),
                                              child: Container(
                                                padding: EdgeInsets.all(10),
                                                child: Center(
                                                    child: Text(
                                                  jobs[index].connectionList.contains(auth.currentUser?.uid ?? "na") ? "Applied" : "Apply Now",
                                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                                                )),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    );
                  },
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
