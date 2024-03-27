import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:twitter_clone/pages/signup.dart';
import 'package:twitter_clone/providers/user_provider.dart';

class SignIn extends ConsumerStatefulWidget {
  const SignIn({super.key});

  @override
  ConsumerState<SignIn> createState() => _SignInState();
}

class _SignInState extends ConsumerState<SignIn> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController emailController =
      TextEditingController();
  final TextEditingController passwordController =
      TextEditingController();
  final GlobalKey<FormState> _signInKey =
      GlobalKey<FormState>();

  RegExp emailValid = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _signInKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const FaIcon(
              FontAwesomeIcons.twitter,
              color: Colors.blue,
              size: 70,
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Log in to Twitter',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            Container(
              margin:
                  const EdgeInsets.fromLTRB(15, 30, 15, 0),
              padding:
                  const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextFormField(
                key: const ValueKey("loginEmail"),
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: 'Enter your email',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                      vertical: 15, horizontal: 20),
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  } else if (!emailValid.hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.all(15),
              padding:
                  const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextFormField(
                key: const ValueKey("loginPassword"),
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: 'Password',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                      vertical: 15, horizontal: 20),
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  } else if (value.length < 6) {
                    return 'Password must be at least 6 letters';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              width: 250,
              decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(30)),
              child: TextButton(
                key: const ValueKey("loginButton"),
                onPressed: () async {
                  if (_signInKey.currentState!.validate()) {
                    debugPrint(
                        'Email: ${emailController.text}');
                    debugPrint(
                        'Password: ${passwordController.text}');
                    try {
                      await _auth
                          .signInWithEmailAndPassword(
                              email: emailController.text,
                              password:
                                  passwordController.text);
                      ref
                          .read(userProvider.notifier)
                          .logIn(emailController.text);
                    } catch (e) {
                      if (!mounted) return;
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(
                              content: Text(e.toString())));
                    }
                  }
                },
                child: const Text(
                  'Login',
                  style: TextStyle(
                      color: Colors.white, fontSize: 18),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) =>
                            const SignUp()));
              },
              child: const Text(
                'Don\'t have an account? Sign up here',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
