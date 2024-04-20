import 'dart:convert';

import 'package:dflutter_main/CandidateDetailScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'Candidate.dart';

class CandidateScreen extends StatefulWidget {
  const CandidateScreen({super.key});

  @override
  State<CandidateScreen> createState() => _CandidateScreenState();
}

class _CandidateScreenState extends State<CandidateScreen> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  FirebaseDatabase database = FirebaseDatabase.instance;
  FirebaseApp secondaryApp = Firebase.app();
  FirebaseAuth auth = FirebaseAuth.instance;

  TextEditingController controller = TextEditingController();

  List<Candidate> candidates = [];
  List<Candidate> filterList = [];

  getData() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref();

    final snapshot = await ref.child('candidate/').get();
    if (snapshot.exists) {
      String data = jsonEncode(snapshot.value);
      List<Object?> tempList = (jsonDecode(data)).entries.map((entry) {
        var tempEntry = entry.value;
         tempEntry["key"] = entry.key;
        return tempEntry;
      }).toList();
      candidates.clear();
      filterList.clear();
      final FirebaseAuth auth = FirebaseAuth.instance;
      for (var value in tempList) {
        if((jsonDecode(jsonEncode(value ?? {})))["uid"].toString()  != (auth.currentUser?.uid ?? "")){
          candidates.add(Candidate(
            key: (jsonDecode(jsonEncode(value ?? {})))["key"].toString(),
            image: (jsonDecode(jsonEncode(value ?? {})))["image"].toString(),
            employmenttype: (jsonDecode(jsonEncode(value ?? {})))["employmenttype"].toString(),
            fname: (jsonDecode(jsonEncode(value ?? {})))["fname"].toString(),
            lname: (jsonDecode(jsonEncode(value ?? {})))["lname"].toString(),
            location: (jsonDecode(jsonEncode(value ?? {})))["location"].toString(),
            recentcompany: (jsonDecode(jsonEncode(value ?? {})))["recentcompany"].toString(),
            recentjob: (jsonDecode(jsonEncode(value ?? {})))["recentjob"].toString(),
            uid: (jsonDecode(jsonEncode(value ?? {})))["uid"].toString(),
            connectionList: (jsonDecode(jsonEncode(value ?? {})))["connectionList"] ?? []
          ));
        }
      }
      filterList = candidates;
      _controller.forward();
      setState(() {});
    } else {
      print('No data available.');
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
    getData();
  }

  void filterLisat(String query) {
    filterList = candidates.where((item) => item.fname.toLowerCase().contains(query.toLowerCase())).toList();
    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Candidates"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: controller,
                decoration:  const InputDecoration(
                  fillColor: Colors.white,
                  prefixIcon: Icon(Icons.search),
                  labelText: 'Search by Candidate Name',
                  hintText: 'hint text',
                  helperText: 'Search for Candidate',
                  filled: true,
                ),
                onChanged: (value) {
                  filterLisat(value);
                },
              ),
            ),
            Expanded(
              child: GridView.builder(
                itemCount: filterList.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 20.0,
                  crossAxisSpacing: 10.0,
                ),
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  
                  
                  return AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _animation.value,
                      child: child,
                    );
                  },
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => CandidateDetailScreen(
                            candidate: filterList[index],
                            index: index,
                            candidateList: filterList,
                          ),
                        ),
                      );
                    },
                    child: Card(
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        padding: const EdgeInsets.all(10),
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                  flex: 2,
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                    ),
                                    child: AspectRatio(
                                      aspectRatio: 1,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(500),
                                        child: Image.asset(
                                          filterList[index].image,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  )),
                              Center(
                                child: Text(
                                  filterList[index].fname ?? "",
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                                ),
                              ),
                              Center(
                                child: Text(
                                  filterList[index].lname ?? "",
                                  style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 15),
                                ),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () async{
                                        if(filterList[index].connectionList.contains(auth.currentUser?.uid ?? "na")){
                                          return;
                                        }
                                        filterList[index].connectionList.add(auth.currentUser?.uid ?? "na");
                                        DatabaseReference userRef = FirebaseDatabase.instance.ref().child('candidate').child(filterList[index].uid);
                                       await userRef.update({
                                          "connectionList": filterList[index].connectionList.toSet().toList(),
                                        });

                                        DatabaseReference myRef = FirebaseDatabase.instance.ref().child('candidate').child(auth.currentUser?.uid ?? "na");
                                        final  snapshot = await myRef.get();
                                        if (snapshot.exists) {
                                          List tempConnectionList =  (jsonDecode(jsonEncode(snapshot.value ?? {})))["connectionList"] ?? [];
                                          tempConnectionList.add(filterList[index].uid);

                                          myRef.update({
                                            "connectionList": tempConnectionList.toSet().toList(),
                                          });
                                        }

                                        setState(() {});
                                      },
                                      child: Card(
                                        color: filterList[index].connectionList.contains(auth.currentUser?.uid ?? "na") ? Colors.green : Colors.blue,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(10),
                                          child: Container(
                                            padding: EdgeInsets.all(10),
                                            child: Center(
                                                child: Text(
                                                  filterList[index].connectionList.contains(auth.currentUser?.uid ?? "na") ? "Connected" : "Connect",
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
                    ),
                  ),
                );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
