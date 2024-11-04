import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseServices {
  Future addUserDetail(Map<String, dynamic> userInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .set(userInfoMap);
  }

  Future addFoodItem(Map<String, dynamic> userInfoMap, String name) async {
    return await FirebaseFirestore.instance.collection(name).add(userInfoMap);
  }

  Future<Stream<QuerySnapshot>> getFoodItem(String name) async {
    return await FirebaseFirestore.instance.collection(name).snapshots();
  }

  Future addFoodtoCart(Map<String, dynamic> userInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .collection('Cart')
        .add(userInfoMap);
  }

  Future<QuerySnapshot> Search(String username) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .where('SearchKey', isEqualTo: username.substring(0, 1).toUpperCase())
        .get();
  }
}
