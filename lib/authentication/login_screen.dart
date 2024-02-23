// ignore_for_file: body_might_complete_normally_catch_error

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:share_ryde/authentication/authentication.dart';
import 'package:share_ryde/authentication/utils/utils.dart';
import 'package:share_ryde/global/global.dart';
import 'package:share_ryde/methods/methods.dart';
import 'package:share_ryde/pages/pages.dart';
import 'package:share_ryde/widgets/widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  CommonMethods commonMethods = CommonMethods();

  checkIfNetworkIsAvailable() {
    commonMethods.checkConectivity(context);

    loginFormValidation();
  }

  loginFormValidation() {
    if (!emailTextEditingController.text.contains('@')) {
      commonMethods.displaySnackBar(context, 'Please write a valid e-mail.');
    } else if (passwordTextEditingController.text.trim().length < 6) {
      commonMethods.displaySnackBar(
          context, 'Your password must to be at least 6 characters');
    } else {
      userLogin();
    }
  }

  userLogin() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) =>
          const LoadingDialog(messageText: 'Logging into your account...'),
    );

    final User? userFirebase = (await FirebaseAuth.instance
            .signInWithEmailAndPassword(
      email: emailTextEditingController.text.trim(),
      password: passwordTextEditingController.text.trim(),
    )
            .catchError((errorMensage) {
      Navigator.pop(context);
      commonMethods.displaySnackBar(
        context,
        errorMensage.toString(),
      );
    }))
        .user;

    if (!context.mounted) return;
    Navigator.pop(context);

    if (userFirebase != null) {
      DatabaseReference usersRef = FirebaseDatabase.instance
          .ref()
          .child('users')
          .child(userFirebase.uid);
      usersRef.once().then((value) {
        if (value.snapshot.value != null) {
          if ((value.snapshot.value as Map)['blockStatus'] == 'no') {
            userName = (value.snapshot.value as Map)['name'];
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const HomePage(),
              ),
            );
          } else {
            FirebaseAuth.instance.signOut();
            commonMethods.displaySnackBar(
                context, 'Your account is blocked. Contact the administrator.');
          }
        } else {
          FirebaseAuth.instance.signOut();
          commonMethods.displaySnackBar(context, 'Your account do not exists.');
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffEFEFEF),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: Column(
            children: [
              Image.asset(
                'assets/images/logo2.png',
              ),
              const SizedBox(
                height: 24,
              ),
              const Text(
                'Login a User\'s Account',
                style: TextStyle(
                  color: Color(0xff222222),
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(
                height: 35,
              ),
              Column(
                children: [
                  RoudedRectangle(
                    textEditingController: emailTextEditingController,
                    textInputType: TextInputType.emailAddress,
                    labelText: 'User e-mail',
                    hintText: 'Type your e-mail',
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  RoudedRectangle(
                    textEditingController: passwordTextEditingController,
                    textInputType: TextInputType.text,
                    labelText: 'User password',
                    hintText: 'Type your password',
                    obscureText: true,
                  ),
                  const SizedBox(
                    height: 33,
                  ),
                  Container(
                    height: 50,
                    width: 160,
                    decoration: const BoxDecoration(
                      color: Color(0xff0c849b),
                      borderRadius: BorderRadius.all(
                        Radius.circular(15),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            checkIfNetworkIsAvailable();
                          },
                          child: const Text(
                            'Log in',
                            style: TextStyle(
                              color: Color(0xffEFEFEF),
                              fontSize: 20,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        color: Color(0xff222222),
                        fontSize: 16,
                      ),
                      children: [
                        const TextSpan(text: 'Don\'t have an account? '),
                        TextSpan(
                          text: 'Sign up',
                          style: const TextStyle(
                            color: Color(0xff0C849B),
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SignUpScreen(),
                                ),
                              );
                            },
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
