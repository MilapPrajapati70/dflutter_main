import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AddJobScreen extends StatefulWidget {
  const AddJobScreen({super.key});

  @override
  State<AddJobScreen> createState() => _AddJobScreenState();
}

class _AddJobScreenState extends State<AddJobScreen> {
  TextEditingController jobtitileController = TextEditingController();
  TextEditingController jobdecController = TextEditingController();
  TextEditingController companyController = TextEditingController();
  TextEditingController locationdecController = TextEditingController();
  TextEditingController salaryController = TextEditingController();
  TextEditingController skillsController = TextEditingController();
  TextEditingController dedlineController = TextEditingController();
  TextEditingController mailController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          "Add Job",
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
                    controller: jobtitileController,
                    decoration: InputDecoration(
                      hintText: 'Job Title',
                      filled: true,
                      border: InputBorder.none,
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? false) {
                        return 'Please enter your Job Title';
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
                    controller: jobdecController,
                    decoration: InputDecoration(
                      hintText: 'Job Description',
                      filled: true,
                      border: InputBorder.none,
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? false) {
                        return 'Please enter your Job Description';
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
                    controller: companyController,
                    decoration: InputDecoration(
                      hintText: 'Company Information:',
                      filled: true,
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {},
                    validator: (value) {
                      if (value?.isEmpty ?? false) {
                        return 'Please enter your Company Information:';
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
                    controller: locationdecController,
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
                    controller: salaryController,
                    decoration: InputDecoration(
                      hintText: 'Salary and Benefits',
                      filled: true,
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {},
                    validator: (value) {
                      if (value?.isEmpty ?? false) {
                        return 'Please enter your Salary and Benefits';
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
                    controller: skillsController,
                    decoration: InputDecoration(
                      hintText: 'Skills and Qualifications',
                      filled: true,
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {},
                    validator: (value) {
                      if (value?.isEmpty ?? false) {
                        return 'Please enter your Skills and Qualifications';
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
                    controller: dedlineController,
                    decoration: InputDecoration(
                      hintText: 'Deadline',
                      filled: true,
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {},
                    validator: (value) {
                      if (value?.isEmpty ?? false) {
                        return 'Please enter your Deadline';
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
                    controller: mailController,
                    decoration: InputDecoration(
                      hintText: 'Contact Mail',
                      filled: true,
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {},
                    validator: (value) {
                      if (value?.isEmpty ?? false) {
                        return 'Please enter your Contact Mail';
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
                  onTap: () async {
                    if (_formKey.currentState?.validate() ?? false) {
                      _formKey.currentState?.save();
                    }
                    await addDataToDataBase();
                    Navigator.pop(context);
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
    DatabaseReference ref = FirebaseDatabase.instance.ref("jobs/");
    await ref.push().set({
      "uid": auth.currentUser?.uid ?? "",
      "jobtitle": jobtitileController.text,
      "jobdec": jobdecController.text,
      "company": companyController.text,
      "location": locationdecController.text,
      "salary": salaryController.text,
      "skills": skillsController.text,
      "deadline": dedlineController.text,
      "mail": mailController.text,
      "image": getImage(),
      "apply" : false
    });
  }

  getImage() {
    List<String> items = ['assets/job1.png', 'assets/job2.png', 'assets/job3.png', 'assets/job4.png', 'assets/job5.png', "assets/job6.png"];
    Random random = Random();
    int randomIndex = random.nextInt(items.length);

    return items[randomIndex];
  }
}
