import 'package:firebase_auth/firebase_auth.dart';

class AuthMethods {
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<User?> getCurrentUser() async {
    return auth.currentUser;
  }

  Future<void> signOut() async {
    await auth.signOut();
  }

  Future<bool> deleteUser() async {
    try {
      User? user = auth.currentUser;
      if (user != null) {
        await user.delete();
        return true;
      } else {
        print("No user is signed in.");
        return false;
      }
    } catch (e) {
      print("Error deleting user: $e");
      return false;
    }
  }
}
