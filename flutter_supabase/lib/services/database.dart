import 'package:supabase_flutter/supabase_flutter.dart';

class DatabaseMethods {
  final supabase = Supabase.instance.client;
  Future<void> addUserInfo(userData) async {
    supabase.from("users").insert(userData).catchError((e) {
      print(e.toString());
    });
  }

  Future<void> addFavouriteArticles(userData) async {
    supabase.from("FavouriteArticles").insert(userData).catchError((e) {
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

  updateUserInfo(String email, String photoUrl) async {
    return supabase
        .from("users")
        .update({'photo_url': photoUrl})
        .eq("userEmail", email)
        .catchError((e) {
          print(e.toString());
        });
  }

  updateUserName(String email, String userName) async {
    return supabase
        .from("users")
        .update({'userName': userName})
        .eq("userEmail", email)
        .catchError((e) {
          print(e.toString());
        });
  }

  Future<Map> getUserProfile(String? email) async {
    return await supabase
        .from("users")
        .select()
        .eq("userEmail", email as Object)
        .single() as Map;
  }
}
