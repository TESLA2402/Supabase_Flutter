import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_supabase/helper/authenticate.dart';
import 'package:flutter_supabase/helper/shared_preferences.dart';
import 'package:flutter_supabase/screens/categorylist.dart';
import 'package:flutter_supabase/screens/home.dart';
import 'package:flutter_supabase/screens/profile.dart';
import 'package:flutter_supabase/services/auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://hrozqiyengdaisqwjgjr.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imhyb3pxaXllbmdkYWlzcXdqZ2pyIiwicm9sZSI6ImFub24iLCJpYXQiOjE2ODM5ODg0OTQsImV4cCI6MTk5OTU2NDQ5NH0.Bamh0AEWw21CQ4qkEA2zZUaFHh4PR2RfwAM2vuMTnQU',
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool? userIsLoggedIn = false;

  @override
  void initState() {
    getLoggedInState();
    super.initState();
  }

  getLoggedInState() async {
    await HelperFunctions.getUserLoggedInSharedPreference().then((value) {
      setState(() {
        userIsLoggedIn = value;
        print(userIsLoggedIn);
      });
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: //Authenticate()
            userIsLoggedIn == true ? Main() : Authenticate());
  }
}

class Main extends StatefulWidget {
  const Main({Key? key}) : super(key: key);

  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  int index = 0;
  final screens = [
    Home(),
    CategoryScreen(),
    ProfileScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "News",
              style: GoogleFonts.roboto(
                textStyle: const TextStyle(
                  color: Colors.blue,
                  fontSize: 26,
                  //fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        actions: <Widget>[
          IconButton(
              onPressed: () async {
                AuthService authService = AuthService();
                await authService.signOut();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => Authenticate()));
              },
              padding: const EdgeInsets.symmetric(horizontal: 16),
              icon: const Icon(
                Icons.logout,
                size: 40,
                color: Colors.blue,
              ))
        ],
        elevation: 0.0,
      ),
      extendBody: true,
      body: screens[index],
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        color: Colors.cyan,
        buttonBackgroundColor: Colors.cyan,
        items: const <Widget>[
          Icon(
            Icons.home,
            size: 30,
            color: Colors.white,
          ),
          Icon(
            Icons.list,
            size: 30,
            color: Colors.white,
          ),
          Icon(
            Icons.account_box,
            size: 30,
            color: Colors.white,
          ),
        ],
        height: 50,
        onTap: (index) => setState(() => this.index = index),
      ),
    );
  }
}
