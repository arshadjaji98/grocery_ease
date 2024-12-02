// ignore_for_file: use_build_context_synchronously
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groceryease_delivery_application/pages/registration/login.dart';

import '../../services/image_picker.dart';
import '../../widgets/widget_support.dart';
import 'add_food.dart';
import 'my_product.dart';
import 'notification_screen.dart';

class HomeAdmin extends StatefulWidget {
  const HomeAdmin({super.key});

  @override
  State<HomeAdmin> createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
  String? storeName;
  String imgUrl = '';

  @override
  void initState() {
    super.initState();
  }


  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LogIn()),
    );
  }

  final controller = Get.put(ImagePickerController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Home Admin"),
      ),
      drawer: SafeArea(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).snapshots(),
          builder: (context,snapshot){
            if(snapshot.hasData){
              return Drawer(
                backgroundColor: Colors.white,
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    DrawerHeader(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Column(
                        children: [
                          Obx(() {
                            return InkWell(
                              onTap: () async {
                                controller.pickImage();
                                imgUrl = await controller.uploadImageToFirebase();
                              },
                              child: CircleAvatar(
                                radius: 50,
                                child: ClipOval(
                                  child: controller.image.value == null ||
                                      controller.image.value!.path == ''
                                      ? Image.network(snapshot.data!.data()!["profile_image"])
                                      : AspectRatio(
                                    aspectRatio: 1.0,
                                    child: Image.file(
                                      controller.image.value!,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                          Text(
                            snapshot.data!.data()!["name"],
                            style: AppWidgets.semiBoldTextFieldStyle(),
                          ),
                        ],
                      ),
                    ),
                    ListTile(
                      leading: const Icon(CupertinoIcons.add_circled, color: Color(0XFF8a4af3)),
                      title: const Text('Add Product',
                        style: TextStyle(color: Color(0XFF8a4af3)),
                      ),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const AddFood()));
                      },
                    ),
                    ListTile(
                      leading:
                      const Icon(CupertinoIcons.chat_bubble, color: Color(0XFF8a4af3)),
                      title: const Text('Chat Screen', style: TextStyle(color: Color(0XFF8a4af3))),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationsScreens()));
                      },
                    ),
                    ListTile(
                      leading: const Icon(CupertinoIcons.cube_box, color: Color(0XFF8a4af3)),
                      title: const Text('My Products', style: TextStyle(color: Color(0XFF8a4af3))),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const MyProducts()));
                      },
                    ),
                    ListTile(
                      leading: const Icon(CupertinoIcons.arrow_right_square, color: Color(0XFF8a4af3)),
                      title: const Text('Logout', style: TextStyle(color: Color(0XFF8a4af3))),
                      onTap: signOut,
                    ),
                  ],
                ),
              );
            }else{
              return Center(child: SizedBox());
            }
          },

        )
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Your Orders",
              style: AppWidgets.boldTextFieldStyle(),
            )
          ],
        ),
      ),
    );
  }
}