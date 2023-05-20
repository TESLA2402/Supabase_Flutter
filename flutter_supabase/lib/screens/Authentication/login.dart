import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_supabase/constants/colors.dart';
import 'package:flutter_supabase/constants/typography.dart';
import 'package:flutter_supabase/helper/shared_preferences.dart';
import 'package:flutter_supabase/main.dart';
import 'package:flutter_supabase/services/auth.dart';

class SignIn extends StatefulWidget {
  final Function toggle;
  SignIn(this.toggle);
  //const SignIn(void Function() toggleView, {Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  final formkey = GlobalKey<FormState>();
  AuthService authService = AuthService();
  bool isLoading = false;
  signIn() async {
    if (formkey.currentState != null) {
      formkey.currentState?.validate();
      HelperFunctions.saveUserEmailSharedPreference(
          emailTextEditingController.text);
    }

    {
      setState(() {
        isLoading = true;
      });
      await authService
          .signInWithEmailAndPassword(emailTextEditingController.text,
              passwordTextEditingController.text)
          .then((result) async {
        //if (result != null) {
        HelperFunctions.saveUserLoggedInSharedPreference(true);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const Main()));
        //}
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(right: 24, left: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedTextKit(
                  animatedTexts: [
                    TypewriterAnimatedText(
                      'Welcome Back',
                      textStyle: const TextStyle(
                        fontSize: 32.0,
                        fontWeight: FontWeight.bold,
                      ),
                      speed: const Duration(milliseconds: 100),
                    ),
                    TypewriterAnimatedText(
                      "Login!",
                      textStyle: const TextStyle(
                        fontSize: 32.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Canterbury',
                      ),
                      speed: const Duration(milliseconds: 100),
                    ),
                  ],
                  totalRepeatCount: 4,
                  pause: const Duration(milliseconds: 1000),
                  displayFullTextOnTap: true,
                  stopPauseOnTap: true,
                ),
                const SizedBox(
                  height: 48,
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border:
                          Border.all(width: 0, color: AppColors.buttonColor),
                      color: const Color.fromARGB(255, 211, 236, 247)),
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      const SizedBox(
                        height: 48,
                      ),
                      Form(
                        key: formkey,
                        child: Column(
                          children: [
                            TextFormField(
                              validator: (val) {
                                return RegExp(
                                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                        .hasMatch(val!)
                                    ? null
                                    : "Please Enter Correct Email";
                              },
                              controller: emailTextEditingController,
                              decoration: InputDecoration(
                                  hintText: "Email",
                                  fillColor: Colors.white,
                                  filled: true,
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6),
                                      borderSide: const BorderSide(
                                          width: 0, color: Colors.white)),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6),
                                      borderSide: const BorderSide(
                                          width: 0, color: Colors.white))),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              obscureText: true,
                              validator: (val) {
                                return val!.length > 6
                                    ? null
                                    : "Enter Password 6+ characters";
                              },
                              controller: passwordTextEditingController,
                              decoration: InputDecoration(
                                  hintText: "Password",
                                  fillColor: Colors.white,
                                  filled: true,
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6),
                                      borderSide: const BorderSide(
                                          width: 0, color: Colors.white)),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6),
                                      borderSide: const BorderSide(
                                          width: 0, color: Colors.white))),
                            ),
                          ],
                        ),
                      ),
                      Container(
                          alignment: Alignment.centerRight,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: const Text("Forgot Password?"),
                          )),
                      const SizedBox(
                        height: 8,
                      ),
                      GestureDetector(
                        onTap: () {
                          signIn();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            height: 60,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color:
                                    const Color.fromARGB(255, 108, 193, 233)),
                            child: Center(
                              child: Text("Log In",
                                  style: AppTypography.textMd.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700)),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(children: <Widget>[
                        Container(
                          padding: const EdgeInsets.only(left: 60),
                          child: const Text("Dont't have account?"),
                        ),
                        Container(
                          alignment: Alignment.bottomCenter,
                          child: TextButton(
                            child: const Text(
                              "SignIn",
                              //style: kSendButtonTextStyle,
                            ),
                            onPressed: () {
                              widget.toggle();
                            },
                          ),
                        ),
                      ])
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
