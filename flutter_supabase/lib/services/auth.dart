// ignore_for_file: unused_local_variable

import 'package:flutter_supabase/constants/constants.dart';
import 'package:flutter_supabase/helper/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      final AuthResponse res = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      final Session? session = res.session;
      final User? user = res.user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signUpWithEmailAndPassword(String email, String password) async {
    try {
      final AuthResponse res = await supabase.auth.signUp(
        email: email,
        password: password,
      );
      final Session? session = res.session;
      final User? user = res.user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signOut() async {
    HelperFunctions.saveUserLoggedInSharedPreference(false);
    try {
      return await supabase.auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
