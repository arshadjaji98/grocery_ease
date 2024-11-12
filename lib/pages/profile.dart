import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:groceryease_delivery_application/pages/registration/login.dart';
import 'package:groceryease_delivery_application/services/database_services.dart';
import 'package:groceryease_delivery_application/services/shared_perf.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String? profile, name, email;
  final ImagePicker _picker = ImagePicker();
  File? selectedImage;
  final TextEditingController addressController = TextEditingController();

  Future getImage() async {
    var image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      selectedImage = File(image.path);
      setState(() {
        uploadItem();
      });
    }
  }

  uploadItem() async {
    if (selectedImage != null) {
      String addId = randomAlphaNumeric(10);
      Reference firebaseStorageRef =
          FirebaseStorage.instance.ref().child("blogImages").child(addId);
      final UploadTask task = firebaseStorageRef.putFile(selectedImage!);

      var downloadUrl = await (await task).ref.getDownloadURL();

      // Clear previous profile image if any and save new one
      await SharedPerfHelper().saveUserProfile(
          downloadUrl); // Save the new image URL in shared preferences

      // Update the profile variable to reflect the new image
      profile = downloadUrl;
      setState(() {});
    }
  }

  getthesharedpref() async {
    // Clear previous profile before loading new one
    profile = null;

    // Fetch new user details
    profile = await SharedPerfHelper().getUserProfile();
    name = await SharedPerfHelper().getUserName();
    email = await SharedPerfHelper().getUserEmail();
    setState(() {});
  }

  onthisload() async {
    await getthesharedpref();
    setState(() {});
  }

  @override
  void initState() {
    onthisload();
    fetchUserAddress();
    fetchUserPhone();
    super.initState();
  }

  String? userPhone;
  Future<void> fetchUserPhone() async {
    String? phone = await SharedPerfHelper().getUserPhone();
    setState(() {
      userPhone = phone;
    });
  }

  String? userAddress;

  Future<void> fetchUserAddress() async {
    String? address = await SharedPerfHelper().getUserAddress();
    setState(() {
      userAddress = address;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: name == null
          ? const Center(
              child: Center(
                  child: SpinKitWave(color: Color(0XFF8a4af3), size: 30)),
            )
          : Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.only(
                              top: 45.0, left: 20.0, right: 20.0),
                          height: MediaQuery.of(context).size.height / 4.3,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: const Color(0XFF8a4af3),
                              borderRadius: BorderRadius.vertical(
                                  bottom: Radius.elliptical(
                                      MediaQuery.of(context).size.width,
                                      105.0))),
                        ),
                        Center(
                          child: Container(
                            margin: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height / 6.5),
                            child: Material(
                              elevation: 10.0,
                              borderRadius: BorderRadius.circular(60),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(60),
                                child: selectedImage == null
                                    ? GestureDetector(
                                        onTap: () {
                                          getImage();
                                        },
                                        child: profile == null
                                            ? Image.asset(
                                                "assets/images/boy.png",
                                                height: 120,
                                                width: 120,
                                                fit: BoxFit.cover,
                                              )
                                            : Image.network(
                                                profile!,
                                                height: 120,
                                                width: 120,
                                                fit: BoxFit.cover,
                                              ),
                                      )
                                    : Image.file(
                                        selectedImage!,
                                        height: 120,
                                        width: 120,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 40.0, right: 15, left: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Welcome  " + name!,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 23.0,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Poppins'),
                              ),
                              Container(
                                height: 35,
                                width: 35,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(color: Colors.white),
                                ),
                                child: GestureDetector(
                                  onTap: () async {
                                    // Show the dialog box for logout confirmation
                                    bool? confirmLogout = await showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text("Confirm Logout"),
                                          content: const Text(
                                              "Do you really want to log out?"),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop(
                                                    false); // Cancel logout
                                              },
                                              child: const Text("No"),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop(
                                                    true); // Confirm logout
                                              },
                                              child: const Text("Yes"),
                                            ),
                                          ],
                                        );
                                      },
                                    );

                                    // If the user confirmed the logout, proceed to sign out
                                    if (confirmLogout == true) {
                                      await DatabaseServices().signOut();
                                      Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                          builder: (context) => const LogIn(),
                                        ),
                                        (Route<dynamic> route) => false,
                                      );
                                    }
                                  },
                                  child: Center(
                                    child: Icon(
                                      Icons.logout,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Material(
                        borderRadius: BorderRadius.circular(10),
                        elevation: 2.0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 15.0,
                            horizontal: 10.0,
                          ),
                          decoration: BoxDecoration(
                              color: const Color(0XFF8a4af3),
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.person,
                                color: Colors.white,
                              ),
                              const SizedBox(
                                width: 20.0,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Name",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    name!,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w600),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30.0),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Material(
                        borderRadius: BorderRadius.circular(10),
                        elevation: 2.0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 15.0,
                            horizontal: 10.0,
                          ),
                          decoration: BoxDecoration(
                              color: const Color(0XFF8a4af3),
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.email,
                                color: Colors.white,
                              ),
                              const SizedBox(
                                width: 20.0,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Email",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    email!,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w600),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Material(
                        borderRadius: BorderRadius.circular(10),
                        elevation: 2.0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 15.0,
                            horizontal: 10.0,
                          ),
                          decoration: BoxDecoration(
                              color: const Color(0XFF8a4af3),
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.phone,
                                color: Colors.white,
                              ),
                              const SizedBox(
                                width: 20.0,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Phone",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    userPhone ?? "No Phone Number",
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w600),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Material(
                        borderRadius: BorderRadius.circular(10),
                        elevation: 2.0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 15.0,
                            horizontal: 10.0,
                          ),
                          decoration: BoxDecoration(
                              color: const Color(0XFF8a4af3),
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.phone,
                                color: Colors.white,
                              ),
                              const SizedBox(
                                width: 20.0,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Address",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    userAddress ?? "No address available",
                                    style: const TextStyle(
                                        fontSize: 16, color: Colors.white),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30.0),
                  ],
                ),
              ),
            ),
    );
  }
}
