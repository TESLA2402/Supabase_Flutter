import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_supabase/constants/colors.dart';
import 'package:flutter_supabase/constants/typography.dart';
import 'package:flutter_supabase/helper/shared_preferences.dart';
import 'package:flutter_supabase/main.dart';
import 'package:flutter_supabase/services/auth.dart';
import 'package:flutter_supabase/services/database.dart';

class SignUp extends StatefulWidget {
  final Function toggle;
  SignUp(this.toggle);
  //const SignUp(void Function() toggleView, {Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isLoading = false;
  DatabaseMethods databaseMethods = DatabaseMethods();
  AuthService authService = AuthService();
  HelperFunctions helperFunctions = HelperFunctions();

  final formkey = GlobalKey<FormState>();
  TextEditingController userNameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  SignMeUP() {
    if (formkey.currentState != null) {
      formkey.currentState?.validate();
    }

    {
      setState(() {
        isLoading = true;
      });
      authService
          .signUpWithEmailAndPassword(emailTextEditingController.text,
              passwordTextEditingController.text)
          .then((val) {
        // print("${val.uid}");
        //if (val != null) {
        Map<String, String> userDataMap = {
          "userName": userNameTextEditingController.text,
          "userEmail": emailTextEditingController.text
        };
        databaseMethods.addUserInfo(userDataMap);
        HelperFunctions.saveUserLoggedInSharedPreference(true);
        HelperFunctions.saveUserEmailSharedPreference(
            emailTextEditingController.text);
        HelperFunctions.saveUserNameSharedPreference(
            userNameTextEditingController.text);

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const Main()));
        //}
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: isLoading
            ? Container(
                child: const Center(child: CircularProgressIndicator()),
              )
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(top: 64, right: 24, left: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AnimatedTextKit(
                        animatedTexts: [
                          TypewriterAnimatedText(
                            'Create Account',
                            textStyle: const TextStyle(
                              fontSize: 32.0,
                              fontWeight: FontWeight.bold,
                            ),
                            speed: const Duration(milliseconds: 100),
                          ),
                          TypewriterAnimatedText(
                            "Sign Up!",
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
                            border: Border.all(
                                width: 0, color: AppColors.buttonColor),
                            color: Color.fromARGB(255, 211, 236, 247)),
                        padding:
                            const EdgeInsets.only(top: 50, left: 24, right: 24),
                        child: Form(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              TextFormField(
                                validator: (val) {
                                  return val!.isEmpty || val.length < 4
                                      ? "Username must contain more than 4 characters"
                                      : null;
                                },
                                controller: userNameTextEditingController,
                                decoration: InputDecoration(
                                    hintText: "User Name",
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
                                height: 15,
                              ),
                              TextFormField(
                                validator: (val) {
                                  return val!.isEmpty || val.length > 6
                                      ? null
                                      : "Password should contain minimum 7 characters";
                                },
                                obscureText: true,
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
                              const SizedBox(
                                height: 15,
                              ),
                              TextFormField(
                                obscureText: true,
                                decoration: InputDecoration(
                                    hintText: "Confirm Password",
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
                                height: 15,
                              ),
                              TextFormField(
                                validator: (val) {
                                  return RegExp(
                                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                          .hasMatch(val!)
                                      ? null
                                      : "Provide a valid Email ID";
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
                                height: 15,
                              ),
                              const SizedBox(
                                height: 8,
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
                                  SignMeUP();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Container(
                                    height: 60,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: AppColors.button,
                                    ),
                                    child: Center(
                                      child: Text("Sign Up",
                                          style: AppTypography.textMd.copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700)),
                                    ),
                                  ),
                                ),
                              ),
                              // Container(
                              //     child: RoundedButton(
                              //   onPressed: () {
                              //     SignMeUP();
                              //   },
                              //   text: 'Sign Up',
                              //   colour: Colors.teal.shade400,
                              // )),
                              Row(children: <Widget>[
                                Container(
                                  padding: const EdgeInsets.only(left: 60),
                                  child: const Text("Already have account?"),
                                ),
                                Container(
                                  alignment: Alignment.bottomCenter,
                                  child: TextButton(
                                    child: const Text(
                                      "LogIn",
                                      //style: kSendButtonTextStyle,
                                    ),
                                    onPressed: () {
                                      widget.toggle();
                                    },
                                  ),
                                )
                              ])
                            ],
                          ),
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
