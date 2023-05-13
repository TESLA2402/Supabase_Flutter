import 'package:flutter_supabase/constants/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DatabaseMethods {
  final supabase = Supabase.instance.client;
  Future<void> addUserInfo(userData) async {
    supabase.from("users").insert(userData).catchError((e) {
      print(e.toString());
    });
  }

  getUserInfo(String email) async {
    return supabase
        .from("users")
        .select("userEmail")
        .eq("userEmail", email)
        .catchError((e) {
      print(e.toString());
    });
  }
}
