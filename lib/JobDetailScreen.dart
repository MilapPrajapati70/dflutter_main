import 'package:dflutter_main/AddJobScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'Job.dart';

class JobDetailScreen extends StatefulWidget {
  Job jobDetail;
  JobDetailScreen({required this.jobDetail,super.key});

  @override
  State<JobDetailScreen> createState() => _JobDetailScreenState();
}

class _JobDetailScreenState extends State<JobDetailScreen> {

  FirebaseAuth auth = FirebaseAuth.instance;


  @override
  Widget build(BuildContext context) {
    return Scaffold(  appBar: AppBar(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      title: const Text(
        "Job Details",
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
      ),
      actions: [
        Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.asset(
                    "assets/img.png",
                  )),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
        const SizedBox(
          width: 10,
        ),
      ],
    ),

      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,

          children: <Widget>[
            AspectRatio(
              aspectRatio: 2,
              child: Image.asset(
                widget.jobDetail.image,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.jobDetail.jobtitle,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.home_work_outlined),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "${widget.jobDetail.company}" ?? "",
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "Location - ${widget.jobDetail.location}" ?? "",
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
                    height: 10,
                  ),
                  Row(
                    children: [
                      const Icon(Icons.timelapse),
                      const SizedBox(width: 10,),
                      Expanded(
                        child: Text(
                          "${widget.jobDetail.deadline}" ?? "",
                          style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10,),
                  Row(
                    children: [
                      const Icon(Icons.mail_outline),
                      const SizedBox(width: 10,),
                      Expanded(
                        child: Text(
                          "${widget.jobDetail.mail}" ?? "",
                          style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10,),
                  Row(
                    children: [
                      const Icon(Icons.money),
                      const SizedBox(width: 10,),
                      Expanded(
                        child: Text(
                          "${widget.jobDetail.salary}" ?? "",
                          style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10,),
                  Row(
                    children: [
                      const Icon(Icons.checklist),
                      const SizedBox(width: 10,),
                      Expanded(
                        child: Text(
                          "${widget.jobDetail.skills}" ?? "",
                          style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10,),
                  Row(
                    children: [
                      const Icon(Icons.description_outlined),
                      const SizedBox(width: 10,),
                      Expanded(
                        child: Text(
                          "${widget.jobDetail.jobdec}" ?? "",
                          style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10,),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () async{
                            if( widget.jobDetail.connectionList.contains(auth.currentUser?.uid ?? "na")){
                              return;
                            }
                            widget.jobDetail.connectionList.add(auth.currentUser?.uid ?? "na");
                            DatabaseReference userRef = FirebaseDatabase.instance.ref().child('jobs').child(widget.jobDetail.key);
                            await userRef.update({
                              "connectionList": widget.jobDetail.connectionList.toSet().toList(),
                            });
                            setState(() {});
                          },
                          child: Card(
                            color:  widget.jobDetail.connectionList.contains(auth.currentUser?.uid ?? "na") ? Colors.green : Colors.blue,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                child: Center(
                                    child: Text(
                                      widget.jobDetail.connectionList.contains(auth.currentUser?.uid ?? "na") ? "Applied" : "Apply Now",
                                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
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
            )
          ],
        ),
      ),
    );
  }
}
