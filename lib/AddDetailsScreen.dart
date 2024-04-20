import 'dart:math';

import 'package:dflutter_main/MyHomePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AddDetailsScreen extends StatefulWidget {
  const AddDetailsScreen({super.key});

  @override
  State<AddDetailsScreen> createState() => _AddDetailsScreenState();
}

class _AddDetailsScreenState extends State<AddDetailsScreen> {
  TextEditingController fnameController = TextEditingController();
  TextEditingController lnameController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController recentjobController = TextEditingController();
  TextEditingController employmenttypeController = TextEditingController();
  TextEditingController recentcompanyController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text(
          "Add Details",
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Card(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: TextFormField(
                    controller: fnameController,
                    decoration: InputDecoration(
                      hintText: 'First Name',
                      filled: true,
                      border: InputBorder.none,
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? false) {
                        return 'Please enter your First Name';
                      }

                      return null;
                    },
                    onChanged: (value) {},
                  ),
                ),
              ),
              Card(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: TextFormField(
                    controller: lnameController,
                    decoration: InputDecoration(
                      hintText: 'Last Name',
                      filled: true,
                      border: InputBorder.none,
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? false) {
                        return 'Please enter your Last Name';
                      }

                      return null;
                    },
                    onChanged: (value) {},
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Card(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: TextFormField(
                    controller: locationController,
                    decoration: InputDecoration(
                      hintText: 'Location',
                      filled: true,
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {},
                    validator: (value) {
                      if (value?.isEmpty ?? false) {
                        return 'Please enter your Location';
                      }

                      return null;
                    },
                  ),
                ),
              ),
              Card(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: TextFormField(
                    controller: recentjobController,
                    decoration: InputDecoration(
                      hintText: 'Recent Job Title',
                      filled: true,
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {},
                    validator: (value) {
                      if (value?.isEmpty ?? false) {
                        return 'Please enter your Recent Job Title';
                      }

                      return null;
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Card(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: TextFormField(
                    controller: employmenttypeController,
                    decoration: InputDecoration(
                      hintText: 'Employment Type',
                      filled: true,
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {},
                    validator: (value) {
                      if (value?.isEmpty ?? false) {
                        return 'Please enter your Employment Type';
                      }

                      return null;
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Card(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: TextFormField(
                    controller: recentcompanyController,
                    decoration: InputDecoration(
                      hintText: 'Recent company',
                      filled: true,
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {},
                    validator: (value) {
                      if (value?.isEmpty ?? false) {
                        return 'Please enter your Recent company';
                      }

                      return null;
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Card(
                margin: EdgeInsets.symmetric(horizontal: 60),
                child: GestureDetector(
                  onTap: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      _formKey.currentState?.save();
                    }
                    addDataToDataBase();
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MyHomePage(title: "Job Search"),
                        ),
                            (route) => false);
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: double.infinity,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.3),
                      ),
                      child: Center(
                          child: Text(
                        "Done",
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
                      )),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  addDataToDataBase() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    DatabaseReference ref = FirebaseDatabase.instance.ref("candidate/${auth.currentUser?.uid ?? ""}");
    await ref.set(
        {
      "uid": auth.currentUser?.uid ?? "",
      "image": getImage(),
      "fname": fnameController.text,
      "lname": lnameController.text,
      "location": locationController.text,
      "recentjob": recentjobController.text,
      "employmenttype": employmenttypeController.text,
      "recentcompany": recentcompanyController.text,
    }
    );
  }

  getImage() {
    List<String> items = ['assets/profile1.png', 'assets/profile2.png', 'assets/profile3.png', 'assets/profile4.png', 'assets/profile5.png', "assets/profile6.png"];
    Random random = Random();
    int randomIndex = random.nextInt(items.length);

    return items[randomIndex];
  }
}
