import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'Candidate.dart';

class CandidateDetailScreen extends StatefulWidget {
  Candidate candidate;
  List<Candidate> candidateList;
  int index;

  CandidateDetailScreen({
    required this.candidate,
    required this.candidateList,
    required this.index,
    super.key,
  });

  @override
  State<CandidateDetailScreen> createState() => _CandidateDetailScreenState();
}

class _CandidateDetailScreenState extends State<CandidateDetailScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Detail Screen"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Stack(
              children: [
                Container(
                    margin: const EdgeInsets.only(bottom: 50),
                    child: AspectRatio(
                      aspectRatio: 1.8,
                      child: Image.asset(
                        "assets/background.png",
                        fit: BoxFit.cover,
                      ),
                    )),
                Positioned(
                  bottom: 0,
                  left: 20,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(500),
                      color: Colors.grey,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(500),
                      child: Image.asset(
                        widget.candidate.image,
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "${widget.candidate.fname ?? ""} ${widget.candidate.lname ?? ""}",
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  widget.candidate.recentjob ?? "",
                                  style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 15),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ))
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      const Icon(Icons.home_work_outlined),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Text(
                          widget.candidate.recentcompany,
                          style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      const Icon(Icons.work_history_outlined),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Text(
                          widget.candidate.recentjob,
                          style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Text(
                          widget.candidate.location,
                          style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  widget.candidate.connectionList.contains(auth.currentUser?.uid ?? "na")
                      ? Row(
                          children: [
                            Expanded(
                              child: Card(
                                color:  widget.candidate.connectionList.contains(auth.currentUser?.uid ?? "na") ? Colors.green : Colors.blue,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    child: Center(
                                        child: Text(
                                          "Connected",
                                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                                    )),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : Row(
                          children: [
                            Expanded(
                              child: Card(
                                color: Colors.blue,
                                child: GestureDetector(
                                  onTap: () async{
                                    if ( widget.candidate.connectionList.contains(auth.currentUser?.uid ?? "na")) {
                                      return;
                                    }

                                    widget.candidate.connectionList.add(auth.currentUser?.uid ?? "na");
                                    DatabaseReference userRef = FirebaseDatabase.instance.ref().child('candidate').child(widget.candidate.uid);
                                    await userRef.update({
                                      "connectionList":widget.candidate.connectionList.toSet().toList(),
                                    });

                                    DatabaseReference myRef = FirebaseDatabase.instance.ref().child('candidate').child(auth.currentUser?.uid ?? "na");
                                    final  snapshot = await myRef.get();
                                    if (snapshot.exists) {
                                      List tempConnectionList =  (jsonDecode(jsonEncode(snapshot.value ?? {})))["connectionList"] ?? [];
                                      tempConnectionList.add(widget.candidate.uid);

                                      myRef.update({
                                        "connectionList": tempConnectionList.toSet().toList(),
                                      });
                                    }

                                    setState(() {});
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      child: const Center(
                                          child: Text(
                                        "Connect",
                                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                                      )),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Card(
                                color: Colors.grey,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      child: const Center(
                                          child: Text(
                                        "Ignore",
                                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                                      )),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                  const SizedBox(
                    height: 10,
                  ),

                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
