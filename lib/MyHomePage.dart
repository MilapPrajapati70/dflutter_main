import 'package:dflutter_main/AddJobScreen.dart';
import 'package:dflutter_main/CandidateScreen.dart';
import 'package:dflutter_main/CreateAccountScreen.dart';
import 'package:dflutter_main/LoginScreen.dart';
import 'package:dflutter_main/PostScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'AddPostScreen.dart';
import 'JobListingScreen.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
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
      drawer: Drawer(
        child: SafeArea(
          child: Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Row(
                    children: [
                      Icon(Icons.home_outlined),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(child: Text("Home")),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: (){
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const AddPostScreen(),
                      ),
                    );
                  },
                  child: const Row(
                    children: [
                      Icon(Icons.post_add),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(child: Text("Posts")),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: (){
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const JobListingScreen(),
                      ),
                    );
                  },
                  child: const Row(
                    children: [
                      Icon(Icons.work_outline),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(child: Text("Jobs")),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const CandidateScreen(),
                      ),
                    );
                  },
                  child: const Row(
                    children: [
                      Icon(Icons.person_outline),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(child: Text("Candidate")),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () async {
                    try {
                      await FirebaseAuth.instance.signOut();
                    } catch (e) {}
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                        (route) => false);
                  },
                  child: const Row(
                    children: [
                      Icon(Icons.logout),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(child: Text("Logout")),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Colors.blue,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(

            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.post_add),
            label: 'Add Post',
          ),
          NavigationDestination(
            icon: Icon(Icons.work_outline),
            label: 'Jobs',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            label: 'Candidates',
          ),
        ],
      ),
      body: [
        PostScreen(
          key: UniqueKey(),
        ),
        AddPostScreen(
          key: UniqueKey(),
        ),
        JobListingScreen(
          key: UniqueKey(),
        ),
        CandidateScreen(
          key: UniqueKey(),
        ),
      ][currentPageIndex],
    );
  }
}
