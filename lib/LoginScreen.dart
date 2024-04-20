import 'package:dflutter_main/CreateAccountScreen.dart';
import 'package:dflutter_main/MyHomePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'AddDetailsScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text(
          "Login",
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
      body: Container(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.width * 0.8,
                  child: Image.asset(
                    "assets/login.png",
                  )),
              Card(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      hintText: 'Email',
                      filled: true,
                      border: InputBorder.none,
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? false) {
                        return 'Please enter your email';
                      }
                      // Regular expression for email validation
                      String pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
                      RegExp regExp = RegExp(pattern);
                      if (!regExp.hasMatch(value ?? "")) {
                        return 'Please enter a valid email address';
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
              Card(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: TextField(
                    controller: passwordController,
                    decoration: const InputDecoration(
                      hintText: 'Password',
                      filled: true,
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {},
                    obscureText: true,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 60),
                child: GestureDetector(
                  onTap: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      _formKey.currentState?.save();
                    }

                    login(emailController.text, passwordController.text);
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
                        "Login",
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
                      )),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 60),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CreateAccountScreen(),
                        ),
                        (route) => false);
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: double.infinity,
                      height: 60,
                      decoration: const BoxDecoration(),
                      child: const Center(
                          child: Text(
                        "Create Account",
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
                      )),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  login(emailAddress, password) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );

      if ((credential.user?.uid) != null) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const MyHomePage(title: "Job Search"),
            ),
            (route) => false);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        const snackBar = SnackBar(
          content: Text('No user found for that email.'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        const snackBar = SnackBar(
          content: Text('Wrong password provided for that user.'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else if (e.code == 'invalid-credential') {
        print('invalid-credential provided for that user.');
        const snackBar = SnackBar(
          content: Text('Invalid-credential provided for that user.'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } catch (e) {
      print(e);
    }
  }
}
