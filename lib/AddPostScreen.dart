import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Add Post"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    Card(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: TextFormField(
                          controller: nameController,
                          decoration: const InputDecoration(
                            hintText: 'Name',
                            filled: true,
                            border: InputBorder.none,
                          ),
                          validator: (value) {
                            if (value?.isEmpty ?? false) {
                              return 'Please enter your Name';
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
                          controller: titleController,
                          decoration: const InputDecoration(
                            hintText: 'Title',
                            filled: true,
                            border: InputBorder.none,
                          ),
                          validator: (value) {
                            if (value?.isEmpty ?? false) {
                              return 'Please enter your Title';
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
                          controller: contentController,
                          minLines: 5,
                          maxLines: 20,
                          decoration: const InputDecoration(
                            hintText: 'Description',
                            filled: true,
                            border: InputBorder.none,
                          ),
                          validator: (value) {
                            if (value?.isEmpty ?? false) {
                              return 'Please enter your Content';
                            }

                            return null;
                          },
                          onChanged: (value) {},
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: GestureDetector(
                onTap: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    _formKey.currentState?.save();
                  }
                  await addDataToDataBase();
                  titleController.clear();
                  contentController.clear();
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    width: double.infinity,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.3),
                    ),
                    child: const Center(
                        child: Text(
                      "Post",
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
                    )),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  addDataToDataBase() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    DatabaseReference ref = FirebaseDatabase.instance.ref("posts/");

    await ref.push().set({
      "uid": auth.currentUser?.uid ?? "",
      "title": titleController.text,
      "name": nameController.text,
      "content": contentController.text,
      "imageUrl": getImage(),
    });
  }

  getImage() {
    List<String> items = ['assets/post1.png', 'assets/post2.png', 'assets/post3.png', 'assets/post4.png'];
    Random random = Random();
    int randomIndex = random.nextInt(items.length);

    return items[randomIndex];
  }
}
