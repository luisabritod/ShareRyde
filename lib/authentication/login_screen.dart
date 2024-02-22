import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:share_ryde/authentication/authentication.dart';
import 'package:share_ryde/authentication/utils/utils.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

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
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => const SignUpScreen(),
                            //   ),
                            // );
                            // criar pagina inicial
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
