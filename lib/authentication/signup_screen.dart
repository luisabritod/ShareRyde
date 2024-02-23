// ignore_for_file: body_might_complete_normally_catch_error, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:share_ryde/authentication/authentication.dart';
import 'package:share_ryde/authentication/utils/utils.dart';
import 'package:share_ryde/methods/methods.dart';
import 'package:share_ryde/pages/home_page.dart';
import 'package:share_ryde/widgets/widgets.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  CommonMethods commonMethods = CommonMethods();

  checkIfNetworkIsAvailable() {
    commonMethods.checkConectivity(context);

    signUpFormValidation();
  }

  signUpFormValidation() {
    if (nameTextEditingController.text.trim().length < 4) {
      commonMethods.displaySnackBar(
          context, 'Your name has to be at least 4 characters.');
    } else if (phoneTextEditingController.text.trim().length < 9) {
      commonMethods.displaySnackBar(
          context, 'Your phone has to be at least 9 characters.');
    } else if (!emailTextEditingController.text.contains('@')) {
      commonMethods.displaySnackBar(
          context, 'Please write a valid email address.');
    } else if (passwordTextEditingController.text.trim().length < 6) {
      commonMethods.displaySnackBar(
          context, 'Your phone has to be at least 6 characters.');
    } else {
      registerNewUser();
    }
  }

  registerNewUser() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) =>
          const LoadingDialog(messageText: 'Registring your account...'),
    );

    final User? userFirebase = (await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
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

    DatabaseReference usersRef =
        FirebaseDatabase.instance.ref().child('users').child(userFirebase!.uid);
    Map userDataMap = {
      'name': nameTextEditingController.text.trim(),
      'email': emailTextEditingController.text.trim(),
      'phone': phoneTextEditingController.text.trim(),
      'id': userFirebase.uid,
      'blockStatus': 'no',
    };
    usersRef.set(userDataMap);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const HomePage(),
      ),
    );
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
                'Create a User\'s Account',
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
                    textEditingController: nameTextEditingController,
                    textInputType: TextInputType.name,
                    labelText: 'User name',
                    hintText: 'Type your name',
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  RoudedRectangle(
                    textEditingController: phoneTextEditingController,
                    textInputType: TextInputType.phone,
                    labelText: 'User phone',
                    hintText: 'Type your phone',
                  ),
                  const SizedBox(
                    height: 25,
                  ),
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
                            'Sign up',
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
                        const TextSpan(text: 'Already have an account? '),
                        TextSpan(
                          text: 'Log in',
                          style: const TextStyle(
                            color: Color(0xff0C849B),
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginScreen(),
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
